---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version: https://www.jetbrains.com/help/teamcity/service-messages.html#Service+Messages+Formats
schema: 2.0.0
---

# Write-TeamCityBuildMessage

## SYNOPSIS
Reports a message for a TeamCity build log

## SYNTAX

### Normal (Default)
```
Write-TeamCityBuildMessage [-Text] <String> [<CommonParameters>]
```

### Error
```
Write-TeamCityBuildMessage [-Text] <String> [-IsError] -ErrorDetails <String> [<CommonParameters>]
```

### Failure
```
Write-TeamCityBuildMessage [-Text] <String> [-IsFailure] [<CommonParameters>]
```

### Warning
```
Write-TeamCityBuildMessage [-Text] <String> [-IsWarning] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Write-TeamCityBuildMessage "Message for the build log"
```

##teamcity\[message text='Message for the build log' status='NORMAL'\]

## PARAMETERS

### -Text
The text content of the build message

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsWarning
Whether this message represents a warning

```yaml
Type: SwitchParameter
Parameter Sets: Warning
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsFailure
Whether this message represents a failure

```yaml
Type: SwitchParameter
Parameter Sets: Failure
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsError
Whether this message represents an error

```yaml
Type: SwitchParameter
Parameter Sets: Error
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorDetails
More detail on the error this message represents

```yaml
Type: String
Parameter Sets: Error
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES
https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Messages+for+Build+Log

'errorDetails' is used only if status is ERROR, in other cases it is ignored.
This message fails the build in case its status is ERROR and the "Fail build
if an error message is logged by build runner" box is checked on the Build
Failure Conditions page of the build configuration.

## RELATED LINKS

[https://www.jetbrains.com/help/teamcity/service-messages.html#Service+Messages+Formats](https://www.jetbrains.com/help/teamcity/service-messages.html#Service+Messages+Formats)

