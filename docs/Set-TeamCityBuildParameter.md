---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version: https://www.jetbrains.com/help/teamcity/service-messages.html#set-parameter
schema: 2.0.0
---

# Set-TeamCityBuildParameter

## SYNOPSIS
Dynamically update build parameters of the running build

## SYNTAX

```
Set-TeamCityBuildParameter [-Name] <String> [-Value] <String> [<CommonParameters>]
```

## DESCRIPTION
By using a dedicated service message in your build script, you can 
dynamically update build parameters of the build right from a build step 
(the parameters need to be defined in the Parameters section of the build 
configuration).

## EXAMPLES

### EXAMPLE 1
```
Set-TeamCityBuildParameter -Name 'system.instance' -Value 'UAT'
```

### EXAMPLE 2
```
Set-TeamCityBuildParameter 'env.database' 'development'
```

## PARAMETERS

### -Name
The build parameter name

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
The build parameter value

```yaml
Type: String
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
The changed build parameters will be available in the build steps following 
the modifying one.
They will also be available as build parameters and can 
be used in the dependent builds via %dep.*% parameter references.

Since the setParameter mechanism does not publish anything to the server 
until the build is finished, it is not possible to get updated parameters 
during the build via the REST API.

When specifying a build parameter's name, mind the prefix:

    - 'system' for system properties.

    - 'env' for environment variables.

    - No prefix for configuration parameters.

## RELATED LINKS

[https://www.jetbrains.com/help/teamcity/service-messages.html#set-parameter](https://www.jetbrains.com/help/teamcity/service-messages.html#set-parameter)

