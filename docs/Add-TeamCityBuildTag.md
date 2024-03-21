---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version: https://www.jetbrains.com/help/teamcity/2023.05/service-messages.html#Adding+and+Removing+Build+Tags
schema: 2.0.0
---

# Add-TeamCityBuildTag

## SYNOPSIS
Adds a new tag to the current build

## SYNTAX

```
Add-TeamCityBuildTag [-Tag] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Adds a new tag to the current build using TeamCity service messages.

## EXAMPLES

### EXAMPLE 1
```
Add-TeamCityBuildTag "My Custom Tag"
```

##teamcity\[addBuildTag 'My Custom Tag'\]

## PARAMETERS

### -Tag
The tag to add

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
Added in 2023.05

## RELATED LINKS

[https://www.jetbrains.com/help/teamcity/2023.05/service-messages.html#Adding+and+Removing+Build+Tags](https://www.jetbrains.com/help/teamcity/2023.05/service-messages.html#Adding+and+Removing+Build+Tags)

