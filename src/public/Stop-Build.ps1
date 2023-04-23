function Stop-Build {
    <#
    .SYNOPSIS
    Stop the currently executing teamcity build

    .DESCRIPTION
    Use this if you need to cancel a build from a script, for example, if a 
    build cannot proceed normally due to the environment, or a build should be 
    canceled form a subproces

    .EXAMPLE
    Stop-TeamCityBuild -Comment 'Cancelling'

    .EXAMPLE
    Stop-TeamCityBuild -Comment 'Cancelling' -ReAddToQueue

    .NOTES
    If required, you can re-add the build to the queue after canceling it. By 
    default, TeamCity will do 3 attempts to re-add the build into the queue.

    .LINK
    https://www.jetbrains.com/help/teamcity/service-messages.html#Canceling+Build+via+Service+Message
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        # The comment to cancel the build with
        $Comment,
        [Parameter()]
        [switch]
        # Re-Add the build to the build queue
        $ReAddToQueue
    )
    if (IsRunningInTeamCity) {
        $ReAdd = if ($ReAddToQueue.IsPresent) {
            " readdToQueue='true'"
        } else {
            ''
        }
        Write-Host "##teamcity[buildStop comment='$(EscapeTeamCityBuildText $Comment)'$ReAdd]"
    }
}