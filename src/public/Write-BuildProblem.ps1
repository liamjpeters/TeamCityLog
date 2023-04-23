function Write-BuildProblem {
    <#
    .SYNOPSIS
    Fails the currently running build with a problem using a service message.

    .DESCRIPTION
    To fail a build directly from the build script, a build problem must be 
    reported. Build problems affect the build status text. They appear on the 
    Build Results page.

    .EXAMPLE
    Write-TeamCityBuildProblem -Description "Unable to access system x"
    "##teamcity[buildProblem description='Unable to access system x']"

    .EXAMPLE
    Write-TeamCityBuildProblem "Unable to access system x"
    ##teamcity[buildProblem description='Unable to access system x']

    .EXAMPLE
    Write-TeamCityBuildProblem -Description "Unable to access system x" -Identity "PRB0000001"
    ##teamcity[buildProblem description='Unable to access system x' identity='PRB0000001']

    .NOTES
    https://data-flair.training/blogs/identifiers-in-java/
    Description is limited to 4,000 symbols (characters). Truncated after that.

    Identity - must be a valid Java ID up to 60 characters. If omitted, the identity
    is calculated based on the description text.

    .LINK
    https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Problems
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        # A human-readable plain text description of the build problem.
        $Description,
        [Parameter(Position = 1)]
        [AllowEmptyString()]
        [string]
        # A unique problem ID. Different problems must have different identities.
        $Identity
    )
    if ($Description.Length -gt 4000) {
        $Description = $Description.Substring(0, 4000)
    }

    if (-not [string]::IsNullOrWhiteSpace($Identity) -and
        $Identity.Length -gt 60) {
        $Identity = $Identity.Substring(0, 60)
    }

    if (IsRunningInTeamCity) {
        $Description = EscapeTeamCityBuildText $Description
        if (-not [string]::IsNullOrWhiteSpace($Identity)) {
            $Identity = EscapeTeamCityBuildText $Identity
            Write-Host "##teamcity[buildProblem description='$Description' identity='$Identity']"
        } else {
            Write-Host "##teamcity[buildProblem description='$Description']"
        }
    } else {
        Write-Error "$Description"
    }
}