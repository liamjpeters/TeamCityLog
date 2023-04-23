function Set-BuildParameter {
    <#
    .SYNOPSIS
    Dynamically update build parameters of the running build

    .DESCRIPTION
    By using a dedicated service message in your build script, you can 
    dynamically update build parameters of the build right from a build step 
    (the parameters need to be defined in the Parameters section of the build 
    configuration).

    .EXAMPLE
    Set-TeamCityBuildParameter -Name 'system.instance' -Value 'UAT'

    .EXAMPLE
    Set-TeamCityBuildParameter 'env.database' 'development'

    .NOTES
    The changed build parameters will be available in the build steps following 
    the modifying one. They will also be available as build parameters and can 
    be used in the dependent builds via %dep.*% parameter references.

    Since the setParameter mechanism does not publish anything to the server 
    until the build is finished, it is not possible to get updated parameters 
    during the build via the REST API.

    When specifying a build parameter's name, mind the prefix:

        - 'system' for system properties.

        - 'env' for environment variables.

        - No prefix for configuration parameters.

    .LINK
    https://www.jetbrains.com/help/teamcity/service-messages.html#set-parameter
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        # The build parameter name
        $Name,
        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyString()]
        [string]
        # The build parameter value
        $Value
    )
    if (IsRunningInTeamCity) {
        Write-Host "##teamcity[setParameter name='$(EscapeTeamCityBuildText $Name)' value='$(EscapeTeamCityBuildText $Value)']"
    } else {
        Write-Host "Set Build Parameter '$Name' to '$Value'"
    }
}