---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version: https://www.jetbrains.com/help/teamcity/service-messages.html#Canceling+Build+via+Service+Message
schema: 2.0.0
---

# Stop-TeamCityBuild

## SYNOPSIS
Stop the currently executing teamcity build

## SYNTAX

```
Stop-TeamCityBuild [-Comment] <String> [-ReAddToQueue] [<CommonParameters>]
```

## DESCRIPTION
Use this if you need to cancel a build from a script, for example, if a 
build cannot proceed normally due to the environment, or a build should be 
canceled form a subproces

## EXAMPLES

### EXAMPLE 1
```
Stop-TeamCityBuild -Comment 'Cancelling'
```

### EXAMPLE 2
```
Stop-TeamCityBuild -Comment 'Cancelling' -ReAddToQueue
```

## PARAMETERS

### -Comment
The comment to cancel the build with

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

### -ReAddToQueue
Re-Add the build to the build queue

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES
If required, you can re-add the build to the queue after canceling it.
By 
default, TeamCity will do 3 attempts to re-add the build into the queue.

## RELATED LINKS

[https://www.jetbrains.com/help/teamcity/service-messages.html#Canceling+Build+via+Service+Message](https://www.jetbrains.com/help/teamcity/service-messages.html#Canceling+Build+via+Service+Message)

