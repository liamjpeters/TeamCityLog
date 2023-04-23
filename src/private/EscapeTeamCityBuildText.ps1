function EscapeTeamCityBuildText {
    <#
    .SYNOPSIS
    Escape text so special characters are interpreted properly in a TeamCity 
    build log.

    .DESCRIPTION
    To have certain special characters properly interpreted by the TeamCity 
    server, they must be preceded by a vertical bar (|).

    .EXAMPLE
    EscapeTeamCityBuildText "This's some text in need of [escaping]`n"

    This|'s some text in need of |[escaping|]|n

    .LINK
    https://www.jetbrains.com/help/teamcity/service-messages.html#Escaped+values

    .NOTES
        ╔═══════════╦═════════════════════════════════╦═══════════╗
        ║ Character ║ Description                     ║ Escape as ║
        ╠═══════════╬═════════════════════════════════╬═══════════╣
        ║ '         ║ Apostrophe                      ║ |'        ║
        ╠═══════════╬═════════════════════════════════╬═══════════╣
        ║ \n        ║ Line Feed                       ║ |n        ║
        ╠═══════════╬═════════════════════════════════╬═══════════╣
        ║ \r        ║ Carriage Return                 ║ |r        ║
        ╠═══════════╬═════════════════════════════════╬═══════════╣
        ║ \uNNNN    ║ Unicode Symbol with code 0xNNNN ║ |0xNNNN   ║
        ╠═══════════╬═════════════════════════════════╬═══════════╣
        ║ |         ║ Vertical bar                    ║ ||        ║
        ╠═══════════╬═════════════════════════════════╬═══════════╣
        ║ [         ║ Opening bracket                 ║ |[        ║
        ╠═══════════╬═════════════════════════════════╬═══════════╣
        ║ ]         ║ Closing bracket                 ║ |]        ║
        ╚═══════════╩═════════════════════════════════╩═══════════╝
    #>
    param (
        [Parameter(Position = 0, ValueFromPipeline)]
        [AllowEmptyString()]
        [string]
        # The text to be escaped
        $Text
    )
    PROCESS {
        if ([string]::IsNullOrEmpty($Text)) {
            return ''
        }
        $StringBuilder = [System.Text.StringBuilder]::new()
        foreach ($Character in $Text.GetEnumerator()) {
            switch ($Character) {
                '|' { 
                    $StringBuilder.Append('||') | Out-Null
                    continue
                }
                "'" { 
                    $StringBuilder.Append('|''') | Out-Null
                    continue
                }
                "`n" { 
                    $StringBuilder.Append('|n') | Out-Null
                    continue
                }
                "`r" { 
                    $StringBuilder.Append('|r') | Out-Null
                    continue
                }
                '[' { 
                    $StringBuilder.Append('|[') | Out-Null
                    continue
                }
                ']' { 
                    $StringBuilder.Append('|]') | Out-Null
                    continue
                }
                [char]0x0085 { 
                    $StringBuilder.Append('|x') | Out-Null
                    continue
                }
                [char]0x2028 { 
                    $StringBuilder.Append('|l') | Out-Null
                    continue
                }
                [char]0x2029 { 
                    $StringBuilder.Append('|p') | Out-Null
                    continue
                }
                Default {
                    if ($PSItem -gt 127) {
                        $StringBuilder.Append($('|0x{0:X4}' -f $([long]$PSItem))) | Out-Null
                    } else {
                        $StringBuilder.Append($PSItem) | Out-Null
                    }
                }
            }
        }
        return $StringBuilder.ToString()
    }
}