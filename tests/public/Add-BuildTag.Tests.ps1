BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Add-BuildTag' {
    It 'Throws when an empty Tag is passed' {
        {
            Add-TeamCityBuildTag -Tag ''
        } | Should -Throw
    }

    It "Doesn't throw when a non-empty Tag is passed" {
        {
            Add-TeamCityBuildTag -Tag 'My Tag' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It 'Allows Tag to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Add-TeamCityBuildTag 'My Tag' 6>&1
        $Res | Should -Be "##teamcity[addBuildTag 'My Tag']"
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
        }
        It 'Outputs the tag but not in a service message' {
            $Res = Add-TeamCityBuildTag -Tag 'My Tag' 6>&1
            $Res | Should -Not -BeLike '##teamcity*'
            $Res | Should -Be "Added build tag 'My Tag'"
        }
        It 'Does not escape Tag text ' {
            $Res = Add-TeamCityBuildTag -Tag '😀' 6>&1
            $Res | Should -Be "Added build tag '😀'"
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It 'Outputs Text' {
            Mock Write-Host {} -ModuleName 'TeamCityLog'
            Add-TeamCityBuildTag -Tag 'My Tag'
            Should -Invoke -CommandName 'Write-Host' -Times 1 -Exactly -ModuleName 'TeamCityLog'
        }
        It 'Outputs the tag in a service message' {
            $Res = Add-TeamCityBuildTag -Tag 'My Tag' 6>&1
            $Res | Should -BeLike '##teamcity*'
        }
        It 'Escapes Tag Text' {
            $Res = Add-TeamCityBuildTag -Tag 'My Tag 😀' 6>&1
            $Res | Should -Be "##teamcity[addBuildTag 'My Tag |0xD83D|0xDE00']"
        }
    }
}
