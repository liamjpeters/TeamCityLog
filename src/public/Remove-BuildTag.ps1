function Remove-BuildTag {
    <#
    .SYNOPSIS
    Removes a tag from the current build

    .DESCRIPTION
    Removes a tag from the current build using TeamCity service messages.

    .EXAMPLE
    Remove-TeamCityBuildTag "My Custom Tag"

    ##teamcity[removeBuildTag 'My Custom Tag']

    .NOTES
    Added in 2023.05

    .LINK
    https://www.jetbrains.com/help/teamcity/2023.05/service-messages.html#Adding+and+Removing+Build+Tags
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        # The tag to remove
        $Tag
    )
    if (IsRunningInTeamCity) {
        Write-Host "##teamcity[removeBuildTag '$(EscapeTeamCityBuildText $Tag)']"
    } else {
        Write-Host "Removed build tag '$Tag'"
    }
}