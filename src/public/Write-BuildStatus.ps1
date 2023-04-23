function Write-BuildStatus {
    <#
    .SYNOPSIS
    Writes to the build output log, setting the status of the build using a 
    service message.

    .DESCRIPTION
    Outputs a well formatted and correctly escaped TeamCity build status to 
    stdout. By default, the {build.status.text} substitution pattern is 
    prepended to the build status text. Use the -NoBuildStatusInText switch to 
    prevent this.

    This should not be used to fail the build. Write-TeamCityBuildProblem 
    should be used instead.

    .EXAMPLE
    Write-TeamCityBuildStatus 'Processed: 10'
    "##teamcity[buildStatus text='{build.status.text} - Processed: 10']"

    .EXAMPLE
    Write-TeamCityBuildStatus 'Processed: 10' -Success
    "##teamcity[buildStatus status='SUCCESS' text='{build.status.text} - Processed: 10']"

    .EXAMPLE
    Write-TeamCityBuildStatus 'Processed: 10' -NoBuildStatusInText
    "##teamcity[buildStatus text='Processed: 10']"

    .LINK
    https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Status
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        # Set the new build status text.
        $Text,
        [Parameter()]
        [switch]
        # Change the build status to Success.
        $Success,
        [Parameter()]
        [switch]
        # Removes the build status from the start of the build status text.
        $NoBuildStatusInText
    )
    if (IsRunningInTeamCity) {
        $Text = EscapeTeamCityBuildText $Text
        if (-not $NoBuildStatusInText.IsPresent) {
            $Text = "{build.status.text} - $Text"
        }
        if ($Success.IsPresent) {
            Write-Host "##teamcity[buildStatus status='SUCCESS' text='$Text']"
        } else {
            Write-Host "##teamcity[buildStatus text='$Text']"
        }
    } else {
        Write-Host "Build Status: '$Text'"
    }
}