function Write-BuildStatistic {
    <#
    .SYNOPSIS
    Reports statistical data back to TeamCity about the build using a service 
    message.

    .DESCRIPTION

    .EXAMPLE
    Write-TeamCityBuildStatistic -Key "MyCustomStatistic" -Value 13.5
    "##teamcity[buildStatisticValue key='MyCustomStatistic' value='13.5']"

    .EXAMPLE
    Write-TeamCityBuildStatistic -Key "MyCustomStatistic" -Value "13.5"
    "##teamcity[buildStatisticValue key='MyCustomStatistic' value='13.5']"

    .EXAMPLE
    Write-TeamCityBuildStatistic "MyCustomStatistic" 13.5
    "##teamcity[buildStatisticValue key='MyCustomStatistic' value='13.5']"

    .EXAMPLE
    Write-TeamCityBuildStatistic "MyCustomStatistic" "1234567890123"
    "##teamcity[buildStatisticValue key='MyCustomStatistic' value='1234567890123'"
    
    .NOTES
    Key must not be equal to any of predefined keys.

    Integer values are interpreted as [int64] as the default [int32]
    cannot be store a large enough value to store 13 digits (which
    is) the limit of the value that TeamCity can handle.

    .LINK
    https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Statistics
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        # BuildType-Unique identifier of the statistic being reported.
        $Key,
        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNull()]
        # A numeric value for the statistic being reported.
        $Value
    )
    $PredefinedKeys = @(
        'ArtifactsSize'
        'VisibleArtifactsSize'
        'buildStageDuration:artifactsPublishing'
        'buildStageDuration:buildStepRunner_*'
        'buildStageDuration:sourcesUpdate'
        'buildStageDuration:dependenciesResolving'
        'BuildDuration'
        'BuildDurationNetTime'
        'CodeCoverageB'
        'CodeCoverageC'
        'CodeCoverageL'
        'CodeCoverageM'
        'CodeCoverageR'
        'CodeCoverageS'
        'CodeCoverageAbsBCovered'
        'CodeCoverageAbsBTotal'
        'CodeCoverageAbsCCovered'
        'CodeCoverageAbsCTotal'
        'CodeCoverageAbsLCovered'
        'CodeCoverageAbsLTotal'
        'CodeCoverageAbsMCovered'
        'CodeCoverageAbsMTotal'
        'CodeCoverageAbsRCovered'
        'CodeCoverageAbsRTotal'
        'CodeCoverageAbsSCovered'
        'CodeCoverageAbsSTotal'
        'DuplicatorStats'
        'TotalTestCount'
        'PassedTestCount'
        'FailedTestCount'
        'IgnoredTestCount'
        'InspectionStatsE'
        'InspectionStatsW'
        'SuccessRate'
        'TimeSpentInQueue'
    )
    foreach ($PredefinedKey in $PredefinedKeys) {
        if ($Key -like $PredefinedKey) {
            throw [System.ArgumentException]::new("Argument 'Key' ('$Key') cannot match a TeamCity Pre-defined key. See this link for more info: https://www.jetbrains.com/help/teamcity/custom-chart.html#Default+Statistics+Values+Provided+by+TeamCity")
        }
    }
    if ($Value -is [string]) {
        if ($Value.indexof('.') -gt -1) {
            # Try interpret as double
            if ($null -eq ($Value -as [double])) {
                throw [System.ArgumentException]::new("Argument 'Value' ($Value) was passed in as a string. It contains a period but cannot be interpretted as a [double].")
            }
            $Value = $Value -as [double]
        } else {
            # Try interpret as int64
            if ($null -eq ($Value -as [int64])) {
                throw [System.ArgumentException]::new("Argument 'Value' ($Value) was passed in as a string. It cannot be interpretted as a [int64].")
            }
            $Value = $Value -as [int64]
        }
    }
    if (($Value -is [int16]) -or ($Value -is [int32]) -or ($Value -is [int64])) {
        $NumDigits = "$Value".Length
        if ($NumDigits -gt 13) {
            throw [System.ArgumentException]::new("Argument 'Value' ('$Value') is an Integer that has more that 13 digits.")
        }
    }
    if (IsRunningInTeamCity) {
        Write-Host "##teamcity[buildStatisticValue key='$(EscapeTeamCityBuildText $Key)' value='$Value']"
    } else {
        Write-Host "Build Statistic: '$Key' -> '$Value'"
    }
}