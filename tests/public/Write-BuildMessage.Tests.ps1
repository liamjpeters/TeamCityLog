BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Write-BuildMessage' {
    It 'Throws when an empty Text is passed' {
        {
            Write-TeamCityBuildMessage -Text ''
        } | Should -Throw
    }

    It "Doesn't throw when a non-empty Text is passed" {
        {
            Write-TeamCityBuildMessage -Text 'Message' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It "Doesn't allow IsWarning and IsFailure to be specified at the same time" {
        {
            Write-TeamCityBuildMessage -Text 'Message' -IsWarning -IsFailure | Out-Null
        } | Should -Throw
    }

    It "Doesn't allow IsWarning and IsError to be specified at the same time" {
        {
            Write-TeamCityBuildMessage -Text 'Message' -IsWarning -IsError | Out-Null
        } | Should -Throw
    }

    It "Doesn't allow IsError and IsFailure to be specified at the same time" {
        {
            Write-TeamCityBuildMessage -Text 'Message' -IsError -IsFailure | Out-Null
        } | Should -Throw
    }

    It "Doesn't allow IsError without ErrorDetail" {
        {
            Write-TeamCityBuildMessage -Text 'Message' -IsError -ErrorDetails $null | Out-Null
        } | Should -Throw
    }

    It 'Allows Text to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Write-TeamCityBuildMessage 'Text' 6>&1
        $Res | Should -Be "##teamcity[message text='Text' status='NORMAL']"
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
        }
        It "Writes the normal message '<Text>' unaltered to the information stream" -ForEach @(
            @{ Text = 'Text' }
            @{ Text = "''" }
            @{ Text = '😀' }
            @{ Text = "`n" }
            @{ Text = "`r" }
            @{ Text = '[]' }
            @{ Text = '|' }
        ) {
            $Res = Write-TeamCityBuildMessage -Text $Text 6>&1
            $Res | Should -Be $Text
        }

        It "Writes the warning message '<Text>' unaltered to the warning stream" -ForEach @(
            @{ Text = 'Text' }
            @{ Text = "''" }
            @{ Text = '😀' }
            @{ Text = "`n" }
            @{ Text = "`r" }
            @{ Text = '[]' }
            @{ Text = '|' }
        ) {
            $Res = Write-TeamCityBuildMessage -Text $Text -IsWarning 3>&1
            $Res | Should -Be $Text
        }

        It "Writes the error message '<Text>' unaltered to the error stream" -ForEach @(
            @{ Text = 'Text' }
            @{ Text = "''" }
            @{ Text = '😀' }
            @{ Text = "`n" }
            @{ Text = "`r" }
            @{ Text = '[]' }
            @{ Text = '|' }
        ) {
            $Res = Write-TeamCityBuildMessage -Text $Text -IsError -ErrorDetails 'errordetails' 2>&1
            $Res | Should -Be $Text
        }

        It "Writes the failure message '<Text>' unaltered to the error stream" -ForEach @(
            @{ Text = 'Text' }
            @{ Text = "''" }
            @{ Text = '😀' }
            @{ Text = "`n" }
            @{ Text = "`r" }
            @{ Text = '[]' }
            @{ Text = '|' }
        ) {
            $Res = Write-TeamCityBuildMessage -Text $Text -IsFailure 2>&1
            $Res | Should -Be $Text
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It "Writes the normal message '<Text>' as a service message" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text' }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildMessage -Text $Text 6>&1
            $Res | Should -Be "##teamcity[message text='$Expected' status='NORMAL']"
        }

        It "Writes the warning message '<Text>' as a service message" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text' }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildMessage -Text $Text -IsWarning 6>&1
            $Res | Should -Be "##teamcity[message text='$Expected' status='WARNING']"
        }

        It "Writes the error message '<Text>' as a service message" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text'; }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildMessage -Text $Text -IsError -ErrorDetails $Text 6>&1
            $Res | Should -Be "##teamcity[message text='$Expected' status='ERROR' errorDetails='$Expected']"
        }

        It "Writes the failure message '<Text>' as a service message" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text'; }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildMessage -Text $Text -IsFailure 6>&1
            $Res | Should -Be "##teamcity[message text='$Expected' status='FAILURE']"
        }
    }
}
