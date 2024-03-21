---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version: https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Status
schema: 2.0.0
---

# Write-TeamCityBuildStatus

## SYNOPSIS
Writes to the build output log, setting the status of the build using a 
service message.

## SYNTAX

```
Write-TeamCityBuildStatus [-Text] <String> [-Success] [-NoBuildStatusInText]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Outputs a well formatted and correctly escaped TeamCity build status to 
stdout.
By default, the {build.status.text} substitution pattern is 
prepended to the build status text.
Use the -NoBuildStatusInText switch to 
prevent this.

This should not be used to fail the build.
Write-TeamCityBuildProblem 
should be used instead.

## EXAMPLES

### EXAMPLE 1
```
Write-TeamCityBuildStatus 'Processed: 10'
"##teamcity[buildStatus text='{build.status.text} - Processed: 10']"
```

### EXAMPLE 2
```
Write-TeamCityBuildStatus 'Processed: 10' -Success
"##teamcity[buildStatus status='SUCCESS' text='{build.status.text} - Processed: 10']"
```

### EXAMPLE 3
```
Write-TeamCityBuildStatus 'Processed: 10' -NoBuildStatusInText
"##teamcity[buildStatus text='Processed: 10']"
```

## PARAMETERS

### -Text
Set the new build status text.

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

### -Success
Change the build status to Success.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoBuildStatusInText
Removes the build status from the start of the build status text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
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

[https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Status](https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Status)

