BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Stop-TeamCityBuild' {
    It 'Throws when an empty Comment is passed' {
        {
            Stop-TeamCityBuild -Comment ''
        } | Should -Throw
    }

    It "Doesn't throw when a non-empty Comment is passed" {
        {
            Stop-TeamCityBuild -Comment 'Cancelling' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It 'Allows Comment to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Stop-TeamCityBuild 'Cancelling' 6>&1
        $Res | Should -Be "##teamcity[buildStop comment='Cancelling']"
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
            Mock Write-Host {} -ModuleName 'TeamCityLog'
        }
        It 'Outputs nothing' {
            Stop-TeamCityBuild 'Cancelling'
            Should -Invoke -CommandName Write-Host -Times 0 -Exactly -ModuleName 'TeamCityLog'
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It "Writes the comment '<Text>' as a service message, without re-adding to queue" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text'; }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Stop-TeamCityBuild -Comment $Text 6>&1
            $Res | Should -Be "##teamcity[buildStop comment='$Expected']"
        }

        It "Writes the comment '<Text>' as a service message, with re-adding to queue" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text'; }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Stop-TeamCityBuild -Comment $Text -ReAddToQueue 6>&1
            $Res | Should -Be "##teamcity[buildStop comment='$Expected' readdToQueue='true']"
        }
        
    }
}
