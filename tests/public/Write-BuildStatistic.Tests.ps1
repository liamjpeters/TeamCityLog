BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
}

Describe 'Write-BuildStatistic' {
    It 'Throws when an empty Key is passed' {
        {
            Write-TeamCityBuildStatistic -Key '' -Value 12
        } | Should -Throw
    }

    It 'Throws when an empty Value is passed' {
        {
            Write-TeamCityBuildStatistic -Key 'Key' -Value $null
        } | Should -Throw
    }

    It "Throws when key matches the predefined key '<Key>'" -ForEach @(
        @{ Key = 'ArtifactsSize' }
        @{ Key = 'VisibleArtifactsSize' }
        @{ Key = 'buildStageDuration:artifactsPublishing' }
        @{ Key = 'buildStageDuration:buildStepRunner_*' }
        @{ Key = 'buildStageDuration:sourcesUpdate' }
        @{ Key = 'buildStageDuration:dependenciesResolving' }
        @{ Key = 'BuildDuration' }
        @{ Key = 'BuildDurationNetTime' }
        @{ Key = 'CodeCoverageB' }
        @{ Key = 'CodeCoverageC' }
        @{ Key = 'CodeCoverageL' }
        @{ Key = 'CodeCoverageM' }
        @{ Key = 'CodeCoverageR' }
        @{ Key = 'CodeCoverageS' }
        @{ Key = 'CodeCoverageAbsBCovered' }
        @{ Key = 'CodeCoverageAbsBTotal' }
        @{ Key = 'CodeCoverageAbsCCovered' }
        @{ Key = 'CodeCoverageAbsCTotal' }
        @{ Key = 'CodeCoverageAbsLCovered' }
        @{ Key = 'CodeCoverageAbsLTotal' }
        @{ Key = 'CodeCoverageAbsMCovered' }
        @{ Key = 'CodeCoverageAbsMTotal' }
        @{ Key = 'CodeCoverageAbsRCovered' }
        @{ Key = 'CodeCoverageAbsRTotal' }
        @{ Key = 'CodeCoverageAbsSCovered' }
        @{ Key = 'CodeCoverageAbsSTotal' }
        @{ Key = 'DuplicatorStats' }
        @{ Key = 'TotalTestCount' }
        @{ Key = 'PassedTestCount' }
        @{ Key = 'FailedTestCount' }
        @{ Key = 'IgnoredTestCount' }
        @{ Key = 'InspectionStatsE' }
        @{ Key = 'InspectionStatsW' }
        @{ Key = 'SuccessRate' }
        @{ Key = 'TimeSpentInQueue' }
    ) {
        {
            Write-TeamCityBuildStatistic -Key $Key -Value 12
        } | Should -Throw
    }

    It 'Throws when a positive integer of more than 13 digits is passed as a value' {
        {
            Write-TeamCityBuildStatistic -Key 'Key' -Value 12345678901234
        } | Should -Throw
    }

    It 'Throws when a negative integer of more than 13 digits is passed as a value' {
        {
            Write-TeamCityBuildStatistic -Key 'Key' -Value -12345678901234
        } | Should -Throw
    }

    It 'Throws when a negative integer of more than 13 digits is passed as a value' {
        {
            Write-TeamCityBuildStatistic -Key 'Key' -Value -12345678901234
        } | Should -Throw
    }

    It 'Throws when a non-numeric value is passed as value' {
        {
            Write-TeamCityBuildStatistic -Key 'Key' -Value 'abc'
        } | Should -Throw
    }

    It 'Does not throws when a numeric value is passed as a string to value' {
        {
            Write-TeamCityBuildStatistic -Key 'Key' -Value '12.234' 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
        }

        It 'Writes the key and value unaltered' {
            $Res = Write-TeamCityBuildStatistic -Key 'Key' -Value 12 6>&1
            $Res | Should -Be "Build Statistic: 'Key' -> '12'"
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It "Writes the statistic '<Key>' = '<Value>' as a service message" -ForEach @(
            @{ Key = 'Key'; Value = 12; ExpectedKey = 'Key'; ExpectedValue = '12' }
            @{ Key = 'Key'; Value = 12.1875; ExpectedKey = 'Key'; ExpectedValue = '12.1875' }
            @{ Key = 'Key'; Value = 1234567890123; ExpectedKey = 'Key'; ExpectedValue = '1234567890123' }
            @{ Key = "''"; Value = '12'; ExpectedKey = "|'|'"; ExpectedValue = '12' }
            @{ Key = '😀'; Value = '12'; ExpectedKey = '|0xD83D|0xDE00'; ExpectedValue = '12' }
            @{ Key = '[]'; Value = '12'; ExpectedKey = '|[|]'; ExpectedValue = '12' }
            @{ Key = '|'; Value = '12'; ExpectedKey = '||'; ExpectedValue = '12' }
        ) {
            $Res = Write-TeamCityBuildStatistic -Key "$Key" -Value $Value 6>&1
            $Res | Should -Be "##teamcity[buildStatisticValue key='$ExpectedKey' value='$ExpectedValue']"
        }
    }
}
