$PesterConfig = New-PesterConfiguration -Hashtable @{
    Run        = @{
        Path                   = @(
            "$PSScriptRoot/public/New-*.Tests.ps1"
            "$PSScriptRoot/public/Open-*.Tests.ps1"
            "$PSScriptRoot/public/Close-*.Tests.ps1"
            "$PSScriptRoot/public/Publish-*.Tests.ps1"
            "$PSScriptRoot/public/Set-*.Tests.ps1"
            "$PSScriptRoot/public/Write-*.Tests.ps1"
            "$PSScriptRoot/public/Stop-*.Tests.ps1"
        )
        Throw                  = $true
        SkipRemainingOnFailure = 'Block'
    }
    Output     = @{
        Verbosity = 'Detailed'
    }
    TestResult = @{
        Enabled      = $true
        OutputFormat = 'NUnit2.5'
    }
}

Invoke-Pester -Configuration $PesterConfig -ErrorAction 'Stop'