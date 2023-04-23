#Requires -Version 5.0
[cmdletbinding()]
param()

# Import Classes in order because of dependencies
$ClassList = @(
    'ValidatePathExistsAttribute.ps1'
)
foreach ($Class in $ClassList) {
    . "$PSScriptRoot\classes\$Class.ps1"
}

# Import everything in sub folders
foreach ($Folder in @('private', 'public')){
    $RootFolder = Join-Path -Path $PSScriptRoot -ChildPath $Folder
    if (Test-Path -Path $RootFolder) {
        # Dot-source each file
        Get-ChildItem -Path $RootFolder -Filter *.ps1 -Recurse |
            Where-Object { $_.name -NotLike '*.Tests.ps1' } |
            ForEach-Object { . $_.FullName }
    }
}

Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\public\*.ps1" -Recurse).basename
