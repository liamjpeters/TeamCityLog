function Write-BuildMessage {
    <#
    .SYNOPSIS
    Reports a message for a TeamCity build log
    .DESCRIPTION

    .EXAMPLE
    Write-TeamCityBuildMessage "Message for the build log"

    ##teamcity[message text='Message for the build log' status='NORMAL']
    .NOTES
    https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Messages+for+Build+Log

    'errorDetails' is used only if status is ERROR, in other cases it is ignored.
    This message fails the build in case its status is ERROR and the "Fail build
    if an error message is logged by build runner" box is checked on the Build
    Failure Conditions page of the build configuration.

    .LINK
    https://www.jetbrains.com/help/teamcity/service-messages.html#Service+Messages+Formats
    #>
    [CmdletBinding(DefaultParameterSetName = 'Normal')]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Normal')]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Warning')]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Failure')]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Error')]
        [ValidateNotNullOrEmpty()]
        [string]
        # The text content of the build message
        $Text,
        [Parameter(ParameterSetName = 'Warning')]
        [switch]
        # Whether this message represents a warning
        $IsWarning,
        [Parameter(ParameterSetName = 'Failure')]
        [switch]
        # Whether this message represents a failure
        $IsFailure,
        [Parameter(ParameterSetName = 'Error', Mandatory)]
        [switch]
        # Whether this message represents an error
        $IsError,
        [Parameter(ParameterSetName = 'Error', Mandatory)]
        [string]
        # More detail on the error this message represents
        $ErrorDetails
    )
    $Status = if ($IsWarning.IsPresent) {
        'WARNING'
    } elseif ($IsFailure.IsPresent) {
        'FAILURE'
    } elseif ($IsError.IsPresent) {
        'ERROR'
    } else {
        'NORMAL'
    }
    $ErrorDetailText = if (-not [string]::IsNullOrEmpty($ErrorDetails)) {
        " errorDetails='$(EscapeTeamCityBuildText $ErrorDetails)'"
    } else {
        ''
    }
    if (IsRunningInTeamCity) {
        Write-Host "##teamcity[message text='$(EscapeTeamCityBuildText $Text)' status='$Status'$ErrorDetailText]"
    } else {
        if ($IsWarning.IsPresent) {
            Write-Warning "$Text"
        } elseif ($IsFailure.IsPresent -or $IsError.IsPresent) {
            Write-Error "$Text"
        } else {
            Write-Host "$Text"
        }
    }
}