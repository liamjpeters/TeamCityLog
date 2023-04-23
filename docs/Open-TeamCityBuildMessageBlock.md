---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version:
schema: 2.0.0
---

# Open-TeamCityBuildMessageBlock

## SYNOPSIS
Blocks are used to group several messages in the build log.

## SYNTAX

```
Open-TeamCityBuildMessageBlock [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Creating a block allows you to fold the log lines between the block in 
TeamCity.
Blocks can be nested.

When you close a block, all its inner blocks are closed automatically.

## EXAMPLES

### EXAMPLE 1
```
Open-TeamCityBuildMessageBlock "Querying ServiceNow"
"##teamcity[blockOpened name='Querying ServiceNow']"
```

## PARAMETERS

### -Name
The name of the block to open

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES
https://www.jetbrains.com/help/teamcity/service-messages.html#Blocks+of+Service+Messages

## RELATED LINKS
