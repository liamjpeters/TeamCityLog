BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Write-BuildProgress' {
    It 'Throws when an empty Message is passed' {
        {
            Write-TeamCityBuildProgress -Message ''
        } | Should -Throw
    }

    It 'Throws when an empty Start is passed' {
        {
            Write-TeamCityBuildProgress -Start ''
        } | Should -Throw
    }

    It 'Throws when an empty Finish is passed' {
        {
            Write-TeamCityBuildProgress -Finish ''
        } | Should -Throw
    }

    It "Doesn't throw when a non-empty Message is passed" {
        {
            Write-TeamCityBuildProgress -Message 'Progress Message' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It "Doesn't throw when a non-empty Start is passed" {
        {
            Write-TeamCityBuildProgress -Start 'Progress Block' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It "Doesn't throw when a non-empty Finish is passed" {
        {
            Write-TeamCityBuildProgress -Finish 'Progress Block' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It 'Allows Message to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Write-TeamCityBuildProgress 'Message' 6>&1
        $Res | Should -Be "##teamcity[progressMessage 'Message']"
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
            Mock Write-Host {} -ModuleName 'TeamCityLog'
        }

        It 'Message outputs nothing' {
            Write-TeamCityBuildProgress -Message 'Progress Message'
            Should -Invoke -CommandName Write-Host -Times 0 -Exactly -ModuleName 'TeamCityLog'
        }

        It 'Start outputs nothing' {
            Write-TeamCityBuildProgress -Start 'Progress Block'
            Should -Invoke -CommandName Write-Host -Times 0 -Exactly -ModuleName 'TeamCityLog'
        }

        It 'Finish outputs nothing' {
            Write-TeamCityBuildProgress -Finish 'Progress Block'
            Should -Invoke -CommandName Write-Host -Times 0 -Exactly -ModuleName 'TeamCityLog'
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It "Writes the progress message '<Text>' as a service message" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text' }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildProgress -Message "$Text" 6>&1
            $Res | Should -Be "##teamcity[progressMessage '$Expected']"
        }

        It "Writes the progress start block '<Text>' as a service message" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text' }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildProgress -Start "$Text" 6>&1
            $Res | Should -Be "##teamcity[progressStart '$Expected']"
        }

        It "Writes the progress Finish block '<Text>' as a service message" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text' }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildProgress -Finish "$Text" 6>&1
            $Res | Should -Be "##teamcity[progressFinish '$Expected']"
        }

    }
}
