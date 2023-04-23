function IsRunningInTeamCity {
    <#
    .SYNOPSIS
    Returns whether the current script is executing in TeamCity

    .DESCRIPTION
    Uses the TEAMCITY_VERSION environment variable to determine if the current
    script is executing on a TeamCity build agent

    .EXAMPLE
    $env:TEAMCITY_VERSION = '9999.99.99'
    IsRunningInTeamCity
    $true
    # Returns true when the environment variable is set

    .EXAMPLE
    IsRunningInTeamCity
    $false
    # Returns false when the environment variable is not set

    .NOTES
    The TEAMCITY_VERSION environment variable is present automatically when a
    build is running on a TeamCity agent.
    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
    )
    return -not [string]::IsNullOrEmpty($env:TEAMCITY_VERSION)
}