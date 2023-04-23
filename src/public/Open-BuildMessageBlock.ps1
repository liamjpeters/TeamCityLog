function Open-BuildMessageBlock {
    <#
    .SYNOPSIS
    Blocks are used to group several messages in the build log.

    .DESCRIPTION
    Creating a block allows you to fold the log lines between the block in 
    TeamCity. Blocks can be nested.

    When you close a block, all its inner blocks are closed automatically.

    .EXAMPLE
    Open-TeamCityBuildMessageBlock "Querying ServiceNow"
    "##teamcity[blockOpened name='Querying ServiceNow']"

    .NOTES
    https://www.jetbrains.com/help/teamcity/service-messages.html#Blocks+of+Service+Messages
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        # The name of the block to open
        $Name
    )
    if (IsRunningInTeamCity) {
        Write-Host "##teamcity[blockOpened name='$(EscapeTeamCityBuildText $Name)']"
    }
}