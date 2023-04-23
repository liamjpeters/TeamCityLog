function IsValidIdentifier {
    <#
    .SYNOPSIS
    Returns whether a string is a valid Java Identifier.

    .DESCRIPTION
    TeamCity Service Message identifiers are required to be valid Java
    identifiers. These are strings which only contain alphanumeric
    characters, '-', and must start with a letter.

    .EXAMPLE
    IsValidIdentifier 'Valid-Identifier001'
    True

    .LINK
    https://www.jetbrains.com/help/teamcity/service-messages.html#Service+messages+formats
    #>
    [CmdletBinding()]
    [OutputType([Boolean])]
    param (
        [Parameter(Position = 0, ValueFromPipeline)]
        [AllowEmptyString()]
        [string]
        # The identifier to check
        $Identifier
    )
    BEGIN {
        $RegexPatternJavaIdentifier = '^[A-Za-z0-9-]+$'
    }
    PROCESS {
        # An empty string is not a valid identifier
        if ([string]::IsNullOrEmpty($Identifier)) {
            return $false
        }

        # Identifiers must start with a letter
        if (-not [char]::IsLetter($Identifier[0])) {
            return $false
        }

        # Identifiers must only contain alphanumeric characters and '-'
        if ($Identifier -notmatch $RegexPatternJavaIdentifier) {
            return $false
        }
        return $true
    }
}