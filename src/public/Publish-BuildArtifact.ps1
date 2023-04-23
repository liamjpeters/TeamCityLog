function Publish-BuildArtifact {
    <#
    .SYNOPSIS
    Publishes a build artifact.

    .DESCRIPTION
    Build artifacts are files produced by the build which are stored on TeamCity
    server and can be downloaded from the TeamCity web UI or used as artifact
    dependencies by other builds. Calling this function allows you to publish
    build artifacts while the build is still running.

    .EXAMPLE
    Publish-TeamCityBuildArtifact -Path 'numbers.csv'
    # Uploads the relative file 'numbers.csv' as an artifact of this build.

    .EXAMPLE
    Publish-TeamCityBuildArtifact -Path 'output'
    # Uploads the contents of the 'Output' directory as artifact of this build.

    .NOTES
    If several publishArtifacts service messages are specified, only
    artifacts defined in the last message will be published. To configure
    publishing of multiple artifact files in one archive, use the Artifact
    paths field of the General Settings page.
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({
            if (-not (Test-Path $_)){
                throw "The path specified ('$_') does not exist."
            }
            return $true
        })]
        [string]
        # The path to the artifact(s) to publish
        $Path
    )
    if (IsRunningInTeamCity) {
        Write-Host "##teamcity[publishArtifacts '$Path']"
    } else {
        Write-Host "Publish Artifact at '$Path'"
    }
}