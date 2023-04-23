function Write-BuildProgress {
    <#
    .SYNOPSIS
    Set the progress of the current build.

    .DESCRIPTION
    Use special progress messages to mark long-running parts in a build
    script. These messages will be shown on the projects dashboard for
    the corresponding build and on the Build Results page.

    .EXAMPLE
    Write-TeamCityBuildProgress -Message 'Starting Stage 2'
    "##teamcity[progressMessage 'Starting Stage 2']"

    .EXAMPLE
    Write-TeamCityBuildProgress 'Starting Stage 2'
    "##teamcity[progressMessage 'Starting Stage 2']"

    .EXAMPLE
    Write-TeamCityBuildProgress -Start 'Stage 2'
    "##teamcity[progressStart 'Stage 2']"

    .EXAMPLE
    Write-TeamCityBuildProgress -Finish 'Stage 2'
    "##teamcity[progressFinish 'Stage 2']"

    .LINK
    https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Progress
    #>
    [CmdletBinding(DefaultParameterSetName = 'message')]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'message', Position = 0)]
        [string]
        # The progress message to report.
        $Message,
        [Parameter(Mandatory, ParameterSetName = 'start')]
        [string]
        # Report the start of a progress block.
        $Start,
        [Parameter(Mandatory, ParameterSetName = 'finish')]
        [string]
        # Report the end of a progress block. Should have the same content as a 
        # previous start message.
        $Finish
    )
    if (IsRunningInTeamCity) {
        if ($PSBoundParameters.ContainsKey('Message')) {
            Write-Host "##teamcity[progressMessage '$(EscapeTeamCityBuildText $Message)']"
        } elseif ($PSBoundParameters.ContainsKey('Start')) {
            Write-Host "##teamcity[progressStart '$(EscapeTeamCityBuildText $Start)']"
        } elseif ($PSBoundParameters.ContainsKey('Finish')) {
            Write-Host "##teamcity[progressFinish '$(EscapeTeamCityBuildText $Finish)']"
        }
    }
}