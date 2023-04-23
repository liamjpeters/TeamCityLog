---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version:
schema: 2.0.0
---

# New-TeamCityBuildMessageBlock

## SYNOPSIS
Blocks are used to group several messages in the build log.

## SYNTAX

```
New-TeamCityBuildMessageBlock [-Name] <String> [-ScriptBlock] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
This function wraps the scriptblock in the names message block.
Doesn't 
create a new scope.

## EXAMPLES

### EXAMPLE 1
```
New-TeamCityBuildMessageBlock 'Querying ServiceNow' {
    ...
}
```

##teamcity\[blockOpened name='Querying ServiceNow'\]
...
##teamcity\[blockClosed name='Querying ServiceNow'\]

## PARAMETERS

### -Name
The name of the block

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

### -ScriptBlock
The content of the script block (executed in the current scope)

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
