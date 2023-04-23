---
external help file: TeamCityLog-help.xml
Module Name: TeamCityLog
online version:
schema: 2.0.0
---

# Publish-TeamCityBuildArtifact

## SYNOPSIS
Publishes a build artifact.

## SYNTAX

```
Publish-TeamCityBuildArtifact [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Build artifacts are files produced by the build which are stored on TeamCity
server and can be downloaded from the TeamCity web UI or used as artifact
dependencies by other builds.
Calling this function allows you to publish
build artifacts while the build is still running.

## EXAMPLES

### EXAMPLE 1
```
Publish-TeamCityBuildArtifact -Path 'numbers.csv'
# Uploads the relative file 'numbers.csv' as an artifact of this build.
```

### EXAMPLE 2
```
Publish-TeamCityBuildArtifact -Path 'output'
# Uploads the contents of the 'Output' directory as artifact of this build.
```

## PARAMETERS

### -Path
The path to the artifact(s) to publish

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
If several publishArtifacts service messages are specified, only
artifacts defined in the last message will be published.
To configure
publishing of multiple artifact files in one archive, use the Artifact
paths field of the General Settings page.

## RELATED LINKS
