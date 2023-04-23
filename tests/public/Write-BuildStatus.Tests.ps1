BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Write-BuildStatus' {
    It 'Throws when an empty Status Text is passed' {
        {
            Write-TeamCityBuildStatus -Text ''
        } | Should -Throw
    }
    
    It 'Does not throw when a non-empty Status Text is passed' {
        {
            Write-TeamCityBuildStatus -Text 'Status Text' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It 'Allows Text to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Write-TeamCityBuildStatus 'Status Text' 6>&1
        $Res | Should -Be "##teamcity[buildStatus text='{build.status.text} - Status Text']"
    }


    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
        }

        It 'Writes the status text unaltered' {
            $Res = Write-TeamCityBuildStatus -Text 'Status Text' 6>&1
            $Res | Should -Be "Build Status: 'Status Text'"
        }

        It 'Writes the status text unaltered, ignoring the Success switch' {
            $Res = Write-TeamCityBuildStatus -Text 'Status Text' -Success 6>&1
            $Res | Should -Be "Build Status: 'Status Text'"
        }

        It 'Writes the status text unaltered, ignoring the NoBuildStatusInText switch' {
            $Res = Write-TeamCityBuildStatus -Text 'Status Text' -NoBuildStatusInText 6>&1
            $Res | Should -Be "Build Status: 'Status Text'"
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It "Writes the Status '<Text>' as a service message. Ommiting the build status text" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text'; }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildStatus -Text "$Text" -NoBuildStatusInText 6>&1
            $Res | Should -Be "##teamcity[buildStatus text='$Expected']"
        }

        It "Writes the Status '<Text>' as a service message. Including the build status text" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text'; }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildStatus -Text "$Text" 6>&1
            $Res | Should -Be "##teamcity[buildStatus text='{build.status.text} - $Expected']"
        }

        It "Writes the Status '<Text>' as a service message. Forcing Success" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text'; }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildStatus -Text "$Text" -Success 6>&1
            $Res | Should -Be "##teamcity[buildStatus status='SUCCESS' text='{build.status.text} - $Expected']"
        }
    }
}
