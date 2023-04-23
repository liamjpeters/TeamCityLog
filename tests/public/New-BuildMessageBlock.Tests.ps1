BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'New-BuildMessageBlock' {
    It 'Throws when an empty Name is passed' {
        {
            New-TeamCityBuildMessageBlock -Name '' -ScriptBlock {

            }
        } | Should -Throw
    }

    It "Doesn't throw when a non-empty Name is passed" {
        {
            New-TeamCityBuildMessageBlock -Name 'Block Name' -ScriptBlock {}
        } | Should -Not -Throw
    }

    It 'Allows Name to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = New-TeamCityBuildMessageBlock 'Block Name' -ScriptBlock {} 6>&1
        $Res[0] | Should -Be "##teamcity[blockOpened name='Block Name']"
        $Res[1] | Should -Be "##teamcity[blockClosed name='Block Name']"
    }

    Context 'When not running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
            Mock Write-Host {} -ModuleName 'TeamCityLog'
        }
        It 'Outputs nothing' {
            New-TeamCityBuildMessageBlock -Name 'Block Name' -ScriptBlock {

            }
            Should -Invoke -CommandName Write-Host -Times 0 -Exactly -ModuleName 'TeamCityLog'
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It 'Outputs Text' {
            Mock Write-Host {} -ModuleName 'TeamCityLog'
            New-TeamCityBuildMessageBlock -Name 'Block Name' -ScriptBlock {}
            Should -Invoke -CommandName 'Write-Host' -Times 2 -Exactly -ModuleName 'TeamCityLog'
        }
        It 'Outputs an Opened and Closed Service Message' {
            $Res = New-TeamCityBuildMessageBlock -Name 'Block Name' -ScriptBlock {} 6>&1
            $Res | Should -HaveCount 2
            $Res[0] | Should -Be "##teamcity[blockOpened name='Block Name']"
            $Res[1] | Should -Be "##teamcity[blockClosed name='Block Name']"
        }
        It 'Escapes Message Block Text' {
            $Res = New-TeamCityBuildMessageBlock -Name "BlockName with special characters: |`n`r['] 😀" -ScriptBlock {} 6>&1
            $Res[0] | Should -Be "##teamcity[blockOpened name='BlockName with special characters: |||n|r|[|'|] |0xD83D|0xDE00']"
            $Res[1] | Should -Be "##teamcity[blockClosed name='BlockName with special characters: |||n|r|[|'|] |0xD83D|0xDE00']"
        }
        It 'Does not create a new scope' {
            New-TeamCityBuildMessageBlock -Name 'BlockName' -ScriptBlock {
                $Res = 'Should Exist'
            } 6>&1 | Out-Null
            $Res | Should -Be 'Should Exist'
        }
    }
}