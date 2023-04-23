function New-BuildMessageBlock {
    <#
    .SYNOPSIS
    Blocks are used to group several messages in the build log.

    .DESCRIPTION
    This function wraps the scriptblock in the names message block. Doesn't 
    create a new scope.

    .EXAMPLE
    New-TeamCityBuildMessageBlock 'Querying ServiceNow' {
        ...
    }

    ##teamcity[blockOpened name='Querying ServiceNow']
    ...
    ##teamcity[blockClosed name='Querying ServiceNow']

    .NOTES
    https://www.jetbrains.com/help/teamcity/service-messages.html#Blocks+of+Service+Messages

    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        # The name of the block
        $Name,
        [Parameter(Mandatory, Position = 1)]
        [scriptblock]
        # The content of the script block (executed in the current scope)
        $ScriptBlock
    )
    if (IsRunningInTeamCity) {
        Write-Host "##teamcity[blockOpened name='$(EscapeTeamCityBuildText $Name)']"
    }
    Invoke-Command -NoNewScope -ScriptBlock $ScriptBlock
    if (IsRunningInTeamCity) {
        Write-Host "##teamcity[blockClosed name='$(EscapeTeamCityBuildText $Name)']"
    }
}