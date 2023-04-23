---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version: https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Progress
schema: 2.0.0
---

# Write-TeamCityBuildProgress

## SYNOPSIS
Set the progress of the current build.

## SYNTAX

### message (Default)
```
Write-TeamCityBuildProgress [-Message] <String> [<CommonParameters>]
```

### start
```
Write-TeamCityBuildProgress -Start <String> [<CommonParameters>]
```

### finish
```
Write-TeamCityBuildProgress -Finish <String> [<CommonParameters>]
```

## DESCRIPTION
Use special progress messages to mark long-running parts in a build
script.
These messages will be shown on the projects dashboard for
the corresponding build and on the Build Results page.

## EXAMPLES

### EXAMPLE 1
```
Write-TeamCityBuildProgress -Message 'Starting Stage 2'
"##teamcity[progressMessage 'Starting Stage 2']"
```

### EXAMPLE 2
```
Write-TeamCityBuildProgress 'Starting Stage 2'
"##teamcity[progressMessage 'Starting Stage 2']"
```

### EXAMPLE 3
```
Write-TeamCityBuildProgress -Start 'Stage 2'
"##teamcity[progressStart 'Stage 2']"
```

### EXAMPLE 4
```
Write-TeamCityBuildProgress -Finish 'Stage 2'
"##teamcity[progressFinish 'Stage 2']"
```

## PARAMETERS

### -Message
The progress message to report.

```yaml
Type: String
Parameter Sets: message
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
Report the start of a progress block.

```yaml
Type: String
Parameter Sets: start
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Finish
Report the end of a progress block.
Should have the same content as a 
previous start message.

```yaml
Type: String
Parameter Sets: finish
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

## RELATED LINKS

[https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Progress](https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Progress)

