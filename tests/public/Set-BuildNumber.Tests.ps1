BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Set-BuildNumber' {
    It 'Throws when an empty BuildNumber is passed' {
        {
            Set-TeamCityBuildNumber -BuildNumber ''
        } | Should -Throw
    }

    It "Doesn't throw when a non-empty Name is passed" {
        {
            Set-TeamCityBuildNumber -BuildNumber '1.2.3' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It 'Allows BuildNumber to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Set-TeamCityBuildNumber '1.2.3' 6>&1
        $Res | Should -Be "##teamcity[buildNumber '1.2.3']"
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
        }
        It 'Outputs the build number but not in a service message' {
            $Res = Set-TeamCityBuildNumber -BuildNumber '1.2.3' 6>&1
            $Res | Should -Not -BeLike '##teamcity*'
            $Res | Should -Be "Set Build Number to '1.2.3'"
        }
        It 'Does not escape BuildNumber text ' {
            $Res = Set-TeamCityBuildNumber -BuildNumber '😀' 6>&1
            $Res | Should -Be "Set Build Number to '😀'"
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It 'Outputs Text' {
            Mock Write-Host {} -ModuleName 'TeamCityLog'
            Set-TeamCityBuildNumber -BuildNumber '1.2.3'
            Should -Invoke -CommandName 'Write-Host' -Times 1 -Exactly -ModuleName 'TeamCityLog'
        }
        It 'Outputs the build number in a service message' {
            $Res = Set-TeamCityBuildNumber -BuildNumber '1.2.3' 6>&1
            $Res | Should -BeLike '##teamcity*'
        }
        It 'Escapes BuildNumber Text' {
            $Res = Set-TeamCityBuildNumber -BuildNumber '1.2.3 😀' 6>&1
            $Res | Should -Be "##teamcity[buildNumber '1.2.3 |0xD83D|0xDE00']"
        }
    }
}
