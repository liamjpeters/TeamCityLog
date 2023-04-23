BeforeAll {
    Import-Module "$PSScriptRoot/../../build/TeamCityLog/TeamCityLog.psd1" -Force
    $TestPath = if ($PSVersionTable.Platform -eq 'Unix') {
        which pwsh
    } else {
        'C:\Windows\System32\kernel32.dll'
    }
}

Describe 'Publish-BuildArtifact' {
    It 'Throws when an empty path is passed' {
        {
            Publish-TeamCityBuildArtifact -Path ''
        } | Should -Throw
    }

    It 'Throws when an invalid path is passed' {
        {
            Publish-TeamCityBuildArtifact -Path 'C:\NoSuch.txt' 6>&1 | Out-Null
        } | Should -Throw
    }

    It "Doesn't throw when a valid path is passed" {
        {
            Publish-TeamCityBuildArtifact -Path $TestPath 6>&1 | Out-Null
        } | Should -Not -Throw
    }

    It 'Allows Path to be passed positionally' {
        $env:TEAMCITY_VERSION = '9999.99.9'
        $Res = Publish-TeamCityBuildArtifact $TestPath 6>&1
        $Res | Should -Be "##teamcity[publishArtifacts '$TestPath']"
    }

    Context 'When Not Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = $null
        }
        It 'Outputs the file path but not in a service message' {
            $Res = Publish-TeamCityBuildArtifact -Path $TestPath 6>&1
            $Res | Should -Not -BeLike '##teamcity*'
            $Res | Should -BeLike "*$TestPath*"
        }
    }

    Context 'When Running in TeamCity' {
        BeforeEach {
            $env:TEAMCITY_VERSION = '9999.99.9'
        }
        It 'Outputs Text' {
            Mock Write-Host {} -ModuleName 'TeamCityLog'
            Publish-TeamCityBuildArtifact -Path $TestPath
            Should -Invoke -CommandName 'Write-Host' -Times 1 -Exactly -ModuleName 'TeamCityLog'
        }

        It 'Outputs the file path in a service message' {
            $Res = Publish-TeamCityBuildArtifact -Path $TestPath 6>&1
            $Res | Should -BeLike '##teamcity*'
            $Res | Should -BeLike "*$TestPath*"
        }
    }
}