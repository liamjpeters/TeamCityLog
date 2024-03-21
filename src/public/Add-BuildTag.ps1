function Add-BuildTag {
    <#
    .SYNOPSIS
    Adds a new tag to the current build

    .DESCRIPTION
    Adds a new tag to the current build using TeamCity service messages.

    .EXAMPLE
    Add-TeamCityBuildTag "My Custom Tag"

    ##teamcity[addBuildTag 'My Custom Tag']

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
        # The tag to add
        $Tag
    )
    if (IsRunningInTeamCity) {
        Write-Host "##teamcity[addBuildTag '$(EscapeTeamCityBuildText $Tag)']"
    } else {
        Write-Host "Added build tag '$Tag'"
    }
}