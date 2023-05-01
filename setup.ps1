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

function Check-Installed {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Command
    )
    $cmd = Get-Command $Command -ErrorAction SilentlyContinue
    return $cmd -ne $null
}

# Step 1: check prerequisites
$prerequisites = @(
    "scoop"
)
$allInstalled = $true
foreach ($cmd in $prerequisites) {
    if (Check-Installed $cmd) {
        Write-Host "${cmd}: installed" -ForegroundColor Green
    } else {
        Write-Host "${cmd}: not installed" -ForegroundColor Red
        $allInstalled = $false
    }
}
if ($allInstalled -eq $false) {
    Write-Host "Please install missing packages"
    Exit
}

# Step 2: prepare
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Host "You may need administrator privileges for some operations" -ForegroundColor Yellow
    $answer = Get-Input -Prompt "Do you still want to continue? [y/n]"
    if ($answer -ne "y") {
        Write-Host "Aborted"
        Exit
    }
}

# Step 3: jobs
if (Confirm-Action -Title "Setup nvim") {
    if (!(Check-Installed "nvim")) {
        scoop bucket add main
        scoop install neovim
    }
    Create-Link -SourcePath "$PSScriptRoot/nvim" -LinkPath "$HOME/AppData/Local/nvim"
}

if (Confirm-Action -Title "Setup wezterm") {
    if (!(Check-Installed "wezterm")) {
        scoop bucket add extras
        scoop install wezterm
    }
    Create-Link -SourcePath "$PSScriptRoot/wezterm/.wezterm.lua" -LinkPath "$HOME/.wezterm.lua"
}

# Step 4: cleanup
