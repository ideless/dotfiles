$ErrorActionPreference = "Stop"

function Create-Link {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$SourcePath,
        [Parameter(Mandatory=$true)]
        [string]$LinkPath
    )
    $linkDir = Split-Path -Path $LinkPath
    if (!(Test-Path -Path $linkDir)) {
        New-Item -ItemType Directory -Path $linkDir | Out-Null
    }
    if (!(Test-Path -Path $LinkPath)) {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $SourcePath | Out-Null
        Write-Host "Created link $LinkPath -> $SourcePath"
    } else {
        if ($SourcePath -ne (Get-Item -Path $LinkPath).Target) {
            $answer = Read-Host "$LinkPath exists and is not a link to $SourcePath. Do you want to override it? [y/n] "
            if ($answer -eq "y") {
                Remove-Item -Path $LinkPath -Recurse -Force | Out-Null
                New-Item -ItemType SymbolicLink -Path $LinkPath -Target $SourcePath | Out-Null
                Write-Host "Created link $LinkPath -> $SourcePath"
            } else {
                Write-Host "Skipping $LinkPath"
            }
        } else {
            Write-Host "Link $LinkPath -> $SourcePath exists"
        }
    }
}

function Confirm-Action {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    Write-Host "--- $Title ---"
    $answer = Read-Host "Do you want to continue? [y/n] "
    if ($answer -eq "y") {
        return $true
    }
    else {
        return $false
    }
}

function Get-Input {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Prompt,
        [string]$DefaultValue
    )
    if ([string]::IsNullOrEmpty($DefaultValue)) {
        $answer = Read-Host -Prompt $Prompt
    }
    else {
        $answer = Read-Host -Prompt "$Prompt (default: $DefaultValue)"
        if ([string]::IsNullOrEmpty($answer)) {
            $answer = $DefaultValue
        }
    }
    return $answer
}

# Step 1: check prerequisites
# Step 2: prepare

# Step 3: jobs
if (Confirm-Action -Title "Setup nvim") {
    Create-Link -SourcePath "$PSScriptRoot/nvim" -LinkPath "$HOME/AppData/Local/nvim"
}

# Step 4: cleanup
