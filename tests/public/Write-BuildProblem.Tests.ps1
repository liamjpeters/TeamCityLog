BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Write-BuildProblem' {
    It 'Throws when an empty Description is passed' {
        {
            Write-TeamCityBuildProblem -Description ''
        } | Should -Throw
    }

    It "Doesn't throw when a non-empty Description is passed" {
        {
            Write-TeamCityBuildProblem -Description 'Problem Description' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It "Doesn't throw when an empty Identity is passed" {
        {
            Write-TeamCityBuildProblem -Description 'Problem Description' -Identity '' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It 'Allows Description to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Write-TeamCityBuildProblem 'Problem Description' 6>&1
        $Res | Should -Be "##teamcity[buildProblem description='Problem Description']"
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
        }

        It "Write the build problem description '<Text>' unaltered to the error stream" -ForEach @(
            @{ Text = 'Text' }
            @{ Text = "''" }
            @{ Text = '😀' }
            @{ Text = "`n" }
            @{ Text = "`r" }
            @{ Text = '[]' }
            @{ Text = '|' }
        ) {
            $Res = Write-TeamCityBuildProblem -Description $Text 2>&1
            $Res | Should -Be $Text
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It "Writes the build problem '<Text>' as a service message" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text' }
            @{ Text = "''"; Expected = "|'|'" }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00' }
            @{ Text = "`n"; Expected = '|n' }
            @{ Text = "`r"; Expected = '|r' }
            @{ Text = '[]'; Expected = '|[|]' }
            @{ Text = '|'; Expected = '||' }
        ) {
            $Res = Write-TeamCityBuildProblem -Description $Text 6>&1
            $Res | Should -Be "##teamcity[buildProblem description='$Expected']"
        }

        It "Writes the build problem '<Text>' as a service message with a supplied identity '<ExpectIdent>'" -ForEach @(
            @{ Text = 'Text'; Expected = 'Text'; ExpectIdent = $true }
            @{ Text = "''"; Expected = "|'|'"; ExpectIdent = $true }
            @{ Text = '😀'; Expected = '|0xD83D|0xDE00'; ExpectIdent = $true }
            @{ Text = "`n"; Expected = '|n'; ExpectIdent = $false }
            @{ Text = "`r"; Expected = '|r'; ExpectIdent = $false }
            @{ Text = '[]'; Expected = '|[|]'; ExpectIdent = $true }
            @{ Text = '|'; Expected = '||'; ExpectIdent = $true }
        ) {
            $Res = Write-TeamCityBuildProblem -Description $Text -Identity $Text 6>&1
            if ($ExpectIdent) {
                $Res | Should -Be "##teamcity[buildProblem description='$Expected' identity='$Expected']"
            } else {
                $Res | Should -Be "##teamcity[buildProblem description='$Expected']"
            }
        }

        It 'Truncates identities longer than 60 characters' {
            $60As = 'A' * 60
            $61As = 'A' * 81
            $Res = Write-TeamCityBuildProblem -Description 'Problem Description' -Identity $61As 6>&1
            $Res | Should -Be "##teamcity[buildProblem description='Problem Description' identity='$60As']"
        }

        It 'Truncates descriptions longer than 4000 characters' {
            $4000As = 'A' * 4000
            $4001As = 'A' * 4001
            $Res = Write-TeamCityBuildProblem -Description "$4001As" 6>&1
            $Res | Should -Be "##teamcity[buildProblem description='$4000As']"
        }

    }
}
