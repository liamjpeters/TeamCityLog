[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]$Author,

    [Parameter()]
    [String]$Version,

    [Parameter()]
    [Bool]$NewRelease = $false,

    [Parameter()]
    [Bool]$UpdateDocs = $false
)

# Synopsis: Initiate the build process
task . InstallDependencies,
    InitaliseBuildDirectory,
    CopyChangeLog,
    UpdateChangeLog,
    CreateRootModule,
    UpdateModuleManifest,
    CreateArchive,
    UpdateDocs,
    UpdateProjectRepo

# Synopsis: Install dependent build modules
task InstallDependencies {
    $Modules = @(
        'PlatyPS'
        'ChangelogManagement'
    )
    foreach ($Module in $Modules) {
        try {
            Import-Module $Module -Force
        } catch {
            Install-Module -Name $Module -Scope CurrentUser -Force -Repository PSGallery
            Import-Module $Module -Force
        }
    }
}

# Synopsis: Create fresh build directories and initalise it with content from the project
task InitaliseBuildDirectory {
    @(
        "$BuildRoot\build"
        "$BuildRoot\build\$($script:ModuleName)"
        "$BuildRoot\release"
    ) | ForEach-Object {
        if (Test-Path $_) {
            Remove-Item -Path $_ -Exclude '.gitkeep' -Recurse -Force
        }
        New-Item -Path $_ -ItemType Directory -Force | Out-Null
    }

    if (Test-Path -Path $BuildRoot\src\* -Include '*format.ps1xml') {
        $script:FormatFiles = Copy-Item -Path $BuildRoot\src\* -Destination $BuildRoot\build\$script:ModuleName -Filter '*format.ps1xml' -PassThru
    }

    Copy-Item -Path $BuildRoot\LICENSE -Destination $BuildRoot\build\$script:ModuleName\LICENSE
    # Copy-Item -Path $BuildRoot\src\en-US -Destination $BuildRoot\build\$script:ModuleName -Recurse
    $script:ManifestFile = Copy-Item -Path $BuildRoot\src\$script:ModuleName.psd1 -Destination $BuildRoot\build\$script:ModuleName\$script:ModuleName.psd1 -PassThru
}

# Synopsis: Get change log data, copy it to the build directory, and create releasenotes.txt
task CopyChangeLog {
    Copy-Item -Path $BuildRoot\CHANGELOG.md -Destination $BuildRoot\build\$script:ModuleName\CHANGELOG.md
    $script:ChangeLogData = Get-ChangeLogData -Path $BuildRoot\CHANGELOG.md

    $EmptyChangeLog = $true

    $ReleaseNotes = foreach ($Property in $script:ChangeLogData.Unreleased[0].Data.PSObject.Properties.Name) {
        $Data = $script:ChangeLogData.Unreleased[0].Data.$Property
        if ($Data) {
            $EmptyChangeLog = $false

            Write-Output ("# {0}" -f $Property)

            foreach ($item in $Data) {
                Write-Output ("- {0}" -f $item)
            }
        }
    }

    if ($EmptyChangeLog -eq $true -or $ReleaseNotes.Count -eq 0) {
        if ($script:NewRelease) {
            throw "Can not build with empty Unreleased section in the change log"
        } else {
            $ReleaseNotes = "None"
        }
    }

    Set-Content -Value $ReleaseNotes -Path $BuildRoot\release\releasenotes.txt -Force
}

# Synopsis: Update CHANGELOG.md (if building a new release with -NewRelease)
task UpdateChangeLog -If ($script:NewRelease) {
    $LinkPattern = @{
        FirstRelease  = 'https://github.com/{0}/{1}/tree/{{CUR}}' -f $script:Author, $script:ModuleName
        NormalRelease = 'https://github.com/{0}/{1}/compare/{{PREV}}..{{CUR}}' -f $script:Author, $script:ModuleName
        Unreleased    = 'https://github.com/{0}/{1}/compare/{{CUR}}..HEAD' -f $script:Author, $script:ModuleName
    }

    Update-Changelog -Path $BuildRoot\build\$script:ModuleName\CHANGELOG.md -ReleaseVersion $script:Version -LinkMode Automatic -LinkPattern $LinkPattern
}

# Synopsis: Creates a single .psm1 file of all private and public functions of the to-be-built module
task CreateRootModule {
    $DevModulePath = "$BuildRoot\src"
    $script:RootModule = "$BuildRoot\build\$($script:ModuleName)\$($script:ModuleName).psm1"

    New-Item -Path $RootModule -ItemType "File" -Force | Out-Null

    switch ('classes', 'data', 'private', 'public') {
        default {
            $Files = @(Get-ChildItem $DevModulePath\$_ -Filter *.ps1 -Recurse)

            if ($Files) {
                foreach ($File in $Files) {
                    Get-Content -Path $File.FullName | Add-Content -Path $RootModule
        
                    # Add new line only if the current file isn't the last one 
                    # (minus 1 because array indexes from 0)
                    if ($Files.IndexOf($File) -ne ($Files.Count - 1)) {
                        Write-Output "" | Add-Content -Path $RootModule
                    }
                }
            }
        }
    }
}

# Synopsis: Update the module manifest in the build directory
task UpdateModuleManifest {

    $FunctionsToExport = @()
    $Files = @(Get-ChildItem $BuildRoot\src\public -Filter *.ps1 -Recurse)
    foreach ($File in $Files) {
        $Tokens = $Errors = @()
        $Ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $File.FullName,
            [ref]$Tokens,
            [ref]$Errors
        )

        if ($errors[0].ErrorId -eq 'FileReadError') {
            throw [InvalidOperationException]::new($Errors[0].Message)
        }
        $FunctionsToExport += $Ast.EndBlock.Statements.Name
    }

    $UpdateModuleManifestSplat = @{
        Path              = $script:ManifestFile
        RootModule        = (Split-Path $script:RootModule -Leaf)
        FunctionsToExport = $FunctionsToExport
        ReleaseNotes      = (Get-Content $BuildRoot\release\releasenotes.txt) -replace '`'
    }

    # Build with pre-release data from the branch if the -Version parameter is not passed (for local development and testing)
    if ($script:Version) {
        $UpdateModuleManifestSplat['ModuleVersion'] = $script:Version
    } else {
        $GitVersion = (gitversion | ConvertFrom-Json)
        $UpdateModuleManifestSplat['ModuleVersion'] = $GitVersion.MajorMinorPatch
        $UpdateModuleManifestSplat['Prerelease'] = $GitVersion.NuGetPreReleaseTag
    }

    if ($script:FormatFiles) {
        $UpdateModuleManifestSplat['FormatsToProcess'] = $script:FormatFiles.Name
    }

    Update-ModuleManifest @UpdateModuleManifestSplat
}

# Synopsis: Create archive of the module
task CreateArchive {
    $ReleaseAsset = "$($script:ModuleName)_$($script:Version).zip" 
    Compress-Archive -Path $BuildRoot\build\$script:ModuleName\* -DestinationPath $BuildRoot\release\$ReleaseAsset -Force
}

# Synopsis: Update documentation (-NewRelease or -UpdateDocs switch parameter)
task UpdateDocs -If ($NewRelease -or $UpdateDocs) {
    Import-Module -Name $BuildRoot\build\$script:ModuleName -Force -Global
    New-MarkdownHelp -Module "$script:ModuleName" -OutputFolder $BuildRoot\docs -Force | Out-Null
}

# Synopsis: Update the project's repository with files updated by the pipeline e.g. module manifest
task UpdateProjectRepo -If ($NewRelease) {
    Copy-Item -Path $BuildRoot\build\$script:ModuleName\CHANGELOG.md -Destination $BuildRoot\CHANGELOG.md

    $ManifestData = Import-PowerShellDataFile -Path $script:ManifestFile

    # Instead of copying the manifest from the .\build directory, update it in place
    # This enables me to keep FunctionsToExport = '*' for development. Therefore instead only update the important bits e.g. version and release notes    
    $UpdateModuleManifestSplat = @{
        Path          = '{0}\src\{1}.psd1' -f $BuildRoot, $script:ModuleName
        ModuleVersion = $ManifestData.ModuleVersion
        ReleaseNotes  = $ManifestData.PrivateData.PSData.ReleaseNotes
    }
    Update-ModuleManifest @UpdateModuleManifestSplat
    
    $null = Test-ModuleManifest -Path "$BuildRoot\src\$($script:ModuleName).psd1"
}

# Synopsis: Set build platform specific environment variables
task SetGitHubActionEnvironmentVariables {
    $Variables = @{
        'GH_USERNAME'    = $Author
        'GH_PROJECTNAME' = $ModuleName
    }
    foreach ($Var in $Variables.GetEnumerator()) {
        Write-Output ("{0}={1}" -f $Var.Key, $Var.Value) | Add-Content -Path $env:GITHUB_ENV
    }
}

# Synopsis: Publish module to the PowerShell Gallery
task PublishModule {
    Publish-Module -Path $BuildRoot\build\$ModuleName -NuGetApiKey $env:PSGALLERY_API_KEY -ErrorAction 'Stop' -Force
}