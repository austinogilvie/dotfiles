# PowerShell profile
# Managed in:
# ~/code/github/austinogilvie/dotfiles/powershell/Microsoft.PowerShell_profile.ps1

# ---------------------------------------------------------------------------
# Prompt
# ---------------------------------------------------------------------------

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "jandedobbeleer" | Invoke-Expression
}

# ---------------------------------------------------------------------------
# Directory navigation
# ---------------------------------------------------------------------------

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    zoxide init powershell | Out-String | Invoke-Expression
}

# ---------------------------------------------------------------------------
# Modern Unix-style command-line tools
# ---------------------------------------------------------------------------

if (Get-Command eza -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -ErrorAction SilentlyContinue

    function ls {
        eza --icons @args
    }

    function ll {
        eza --long --icons --git @args
    }

    function la {
        eza --long --all --icons --git @args
    }

    function lt {
        eza --tree --level=2 --icons @args
    }
}

# Use ripgrep when explicitly invoking grep.
if (Get-Command rg -ErrorAction SilentlyContinue) {
    Set-Alias -Name grep -Value rg
}

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------

$env:EDITOR = "code"
$env:VISUAL = "code"

# Keep Python output readable and immediate in command-line applications.
$env:PYTHONUTF8 = "1"
$env:PYTHONUNBUFFERED = "1"

# ---------------------------------------------------------------------------
# Git helpers
# ---------------------------------------------------------------------------

function gs {
    git status --short --branch
}

function gd {
    git diff @args
}

function gl {
    git log --graph --decorate --oneline --all @args
}

function root {
    $repositoryRoot = git rev-parse --show-toplevel 2>$null

    if (!$repositoryRoot) {
        Write-Error "The current directory is not inside a Git repository."
        return
    }

    Set-Location $repositoryRoot
}

# ---------------------------------------------------------------------------
# Convenience helpers
# ---------------------------------------------------------------------------

function which {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Command
    )

    Get-Command $Command |
        Select-Object -ExpandProperty Source
}

function touch {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]]$Path
    )

    foreach ($item in $Path) {
        if (Test-Path $item) {
            (Get-Item $item).LastWriteTime = Get-Date
            continue
        }

        New-Item -ItemType File -Path $item | Out-Null
    }
}

function mkcd {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )

    New-Item -ItemType Directory -Force -Path $Path | Out-Null
    Set-Location $Path
}