param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [Parameter(Mandatory = $true)][string]$ProjectName,
    [Parameter(Mandatory = $true)][string]$Department,
    [Parameter(Mandatory = $true)][string]$Object,
    [Parameter(Mandatory = $true)][string]$Characteristic,
    [string]$Version,
    [Parameter(Mandatory = $true)][string]$Cluster,
    [Parameter(Mandatory = $true)][string]$Phase,
    [Parameter(Mandatory = $true)][string]$Priority,
    [Parameter(Mandatory = $true)][string]$Outcome,
    [Parameter(Mandatory = $true)][string]$BusinessOwner,
    [Parameter(Mandatory = $true)][string]$BA,
    [string[]]$TechnicalMembers = @(),
    [Parameter(Mandatory = $true)][string]$BusinessProblem,
    [Parameter(Mandatory = $true)][string]$TargetUsers,
    [Parameter(Mandatory = $true)][string]$SourceData,
    [Parameter(Mandatory = $true)][string]$NextAction,
    [switch]$CreateCanvasCard
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if ($DryRun -and $Apply) {
    throw "Use either -DryRun or -Apply, not both."
}
if (-not $Apply) {
    $DryRun = $true
}

function Test-PPJPlaceholderValue {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $true }
    $forbidden = @(
        "PROJECT_NAME", "DEPARTMENT", "OBJECT", "PURPOSE", "OUTCOME",
        "PASTE UPDATE HERE", "INTAKE_FILE.md", "CLUSTER", "TBD"
    )
    foreach ($item in $forbidden) {
        if ($Value.Trim() -ieq $item) { return $true }
    }
    return $false
}

$requiredValues = @(
    $ProjectName, $Department, $Object, $Characteristic, $Cluster, $Phase,
    $Priority, $Outcome, $BusinessOwner, $BA, $BusinessProblem,
    $TargetUsers, $SourceData, $NextAction
)
foreach ($value in $requiredValues) {
    if (Test-PPJPlaceholderValue $value) {
        throw "Required registration metadata is blank or contains a placeholder."
    }
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$enginePath = Join-Path $scriptRoot "register_ppj_project.py"
if (-not (Test-Path -LiteralPath $enginePath)) {
    throw "Registration engine not found: $enginePath"
}

$pythonCommand = Get-Command "python3" -ErrorAction SilentlyContinue
if (-not $pythonCommand) {
    $pythonCommand = Get-Command "python" -ErrorAction SilentlyContinue
}
if (-not $pythonCommand) {
    throw "Python 3 is required but was not found on PATH."
}

$engineArgs = @(
    $enginePath,
    $(if ($Apply) { "--apply" } else { "--dry-run" }),
    "--project-name", $ProjectName,
    "--department", $Department,
    "--object", $Object,
    "--characteristic", $Characteristic,
    "--cluster", $Cluster,
    "--phase", $Phase,
    "--priority", $Priority,
    "--outcome", $Outcome,
    "--business-owner", $BusinessOwner,
    "--ba", $BA,
    "--business-problem", $BusinessProblem,
    "--target-users", $TargetUsers,
    "--source-data", $SourceData,
    "--next-action", $NextAction
)
if (-not [string]::IsNullOrWhiteSpace($Version)) {
    $engineArgs += @("--version", $Version)
}
foreach ($member in $TechnicalMembers) {
    if (-not [string]::IsNullOrWhiteSpace($member)) {
        $engineArgs += @("--technical-members", $member)
    }
}
if ($Force) { $engineArgs += "--force" }
if ($CreateCanvasCard) { $engineArgs += "--create-canvas-card" }

& $pythonCommand.Source @engineArgs
exit $LASTEXITCODE

