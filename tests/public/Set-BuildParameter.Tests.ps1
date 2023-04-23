BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Set-BuildParameter' {
    It 'Throws when an empty Name is passed' {
        {
            Set-TeamCityBuildParameter -Name '' -Value 'Value'
        } | Should -Throw
    }

    It "Doesn't throw when a non-empty Name is passed" {
        {
            Set-TeamCityBuildParameter -Name 'Name' -Value 'Value' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It "Doesn't throw when an empty Value is passed" {
        {
            Set-TeamCityBuildParameter -Name 'Name' -Value '' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It 'Allows Name and Value to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Set-TeamCityBuildParameter 'Name' 'Value' 6>&1
        $Res | Should -Be "##teamcity[setParameter name='Name' value='Value']"
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
        }
        It 'Outputs the name and value but not in a service message' {
            $Res = Set-TeamCityBuildParameter -Name 'Name' -Value 'Value' 6>&1
            $Res | Should -Not -BeLike '##teamcity*'
        }
        It 'Does not escape Name or Value text' {
            $Res = $Res = Set-TeamCityBuildParameter -Name '🌵' -Value '😀' 6>&1
            $Res | Should -Be "Set Build Parameter '🌵' to '😀'"
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It 'Outputs Text' {
            Mock Write-Host {} -ModuleName 'TeamCityLog'
            Set-TeamCityBuildParameter -Name 'Name' -Value 'Value'
            Should -Invoke -CommandName 'Write-Host' -Times 1 -Exactly -ModuleName 'TeamCityLog'
        }
        It 'Outputs the name and value in a service message' {
            $Res = Set-TeamCityBuildParameter -Name 'Name' -Value 'Value' 6>&1
            $Res | Should -BeLike '##teamcity*'
        }
        It 'Escapes name Text' {
            $Res = Set-TeamCityBuildParameter -Name '😀' -Value 'Value' 6>&1
            $Res | Should -Be "##teamcity[setParameter name='|0xD83D|0xDE00' value='Value']"
        }

        It 'Escapes value Text' {
            $Res = Set-TeamCityBuildParameter -Name 'Name' -Value '🌵' 6>&1
            $Res | Should -Be "##teamcity[setParameter name='Name' value='|0xD83C|0xDF35']"
        }
        
    }
}
