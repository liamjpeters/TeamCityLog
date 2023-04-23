---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version: https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Statistics
schema: 2.0.0
---

# Write-TeamCityBuildStatistic

## SYNOPSIS
Reports statistical data back to TeamCity about the build using a service 
message.

## SYNTAX

```
Write-TeamCityBuildStatistic [-Key] <String> [-Value] <Object> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Write-TeamCityBuildStatistic -Key "MyCustomStatistic" -Value 13.5
"##teamcity[buildStatisticValue key='MyCustomStatistic' value='13.5']"
```

### EXAMPLE 2
```
Write-TeamCityBuildStatistic -Key "MyCustomStatistic" -Value "13.5"
"##teamcity[buildStatisticValue key='MyCustomStatistic' value='13.5']"
```

### EXAMPLE 3
```
Write-TeamCityBuildStatistic "MyCustomStatistic" 13.5
"##teamcity[buildStatisticValue key='MyCustomStatistic' value='13.5']"
```

### EXAMPLE 4
```
Write-TeamCityBuildStatistic "MyCustomStatistic" "1234567890123"
"##teamcity[buildStatisticValue key='MyCustomStatistic' value='1234567890123'"
```

## PARAMETERS

### -Key
BuildType-Unique identifier of the statistic being reported.

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

### -Value
A numeric value for the statistic being reported.

```yaml
Type: Object
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
Key must not be equal to any of predefined keys.

Integer values are interpreted as \[int64\] as the default \[int32\]
cannot be store a large enough value to store 13 digits (which
is) the limit of the value that TeamCity can handle.

## RELATED LINKS

[https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Statistics](https://www.jetbrains.com/help/teamcity/service-messages.html#Reporting+Build+Statistics)

