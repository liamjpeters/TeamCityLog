---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version: https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Problems
schema: 2.0.0
---

# Write-TeamCityBuildProblem

## SYNOPSIS
Fails the currently running build with a problem using a service message.

## SYNTAX

```
Write-TeamCityBuildProblem [-Description] <String> [[-Identity] <String>] [<CommonParameters>]
```

## DESCRIPTION
To fail a build directly from the build script, a build problem must be 
reported.
Build problems affect the build status text.
They appear on the 
Build Results page.

## EXAMPLES

### EXAMPLE 1
```
Write-TeamCityBuildProblem -Description "Unable to access system x"
"##teamcity[buildProblem description='Unable to access system x']"
```

### EXAMPLE 2
```
Write-TeamCityBuildProblem "Unable to access system x"
##teamcity[buildProblem description='Unable to access system x']
```

### EXAMPLE 3
```
Write-TeamCityBuildProblem -Description "Unable to access system x" -Identity "PRB0000001"
##teamcity[buildProblem description='Unable to access system x' identity='PRB0000001']
```

## PARAMETERS

### -Description
A human-readable plain text description of the build problem.

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

### -Identity
A unique problem ID.
Different problems must have different identities.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
https://data-flair.training/blogs/identifiers-in-java/
Description is limited to 4,000 symbols (characters).
Truncated after that.

Identity - must be a valid Java ID up to 60 characters.
If omitted, the identity
is calculated based on the description text.

## RELATED LINKS

[https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Problems](https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Problems)

