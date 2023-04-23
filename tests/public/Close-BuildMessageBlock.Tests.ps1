BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Close-BuildMessageBlock' {
    It 'Throws when an empty Name is passed' {
        {
            Close-TeamCityBuildMessageBlock -Name ''
        } | Should -Throw
    }

    It "Doesn't throw when a non-empty Name is passed" {
        {
            Close-TeamCityBuildMessageBlock -Name 'Block Name' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It 'Allows Name to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Close-TeamCityBuildMessageBlock 'Block Name' 6>&1
        $Res | Should -Be "##teamcity[blockClosed name='Block Name']"
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
            Mock Write-Host {} -ModuleName 'TeamCityLog'
        }
        It 'Outputs nothing' {
            Close-TeamCityBuildMessageBlock -Name 'Block Name'
            Should -Invoke -CommandName Write-Host -Times 0 -Exactly -ModuleName 'TeamCityLog'
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It 'Outputs Text' {
            Mock Write-Host {} -ModuleName 'TeamCityLog'
            Close-TeamCityBuildMessageBlock -Name 'Block Name'
            Should -Invoke -CommandName 'Write-Host' -Times 1 -Exactly -ModuleName 'TeamCityLog'
        }
        It 'Escapes Message Block Text' {
            $Res = Close-TeamCityBuildMessageBlock -Name "BlockName with special characters: |`n`r['] 😀" 6>&1
            $Res | Should -Be "##teamcity[blockClosed name='BlockName with special characters: |||n|r|[|'|] |0xD83D|0xDE00']"
        }
    }
}