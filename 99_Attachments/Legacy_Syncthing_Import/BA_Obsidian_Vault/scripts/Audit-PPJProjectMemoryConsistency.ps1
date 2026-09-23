param(
    [switch]$DryRun,
    [switch]$ExportReport,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

if (-not $DryRun) {
    $DryRun = $true
}

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$VaultRoot = (Get-Location).Path
$ProjectsRoot = Join-Path $VaultRoot "03_Projects"
$RegistryRoot = Join-Path $ProjectsRoot "_Registry"
$MemoryRoot = Join-Path $RegistryRoot "Project_Memory"
$ReportsRoot = Join-Path $VaultRoot "10_Reports"

function Read-TextSafe {
    param([string]$Path)
    if (Test-Path $Path) {
        return (Get-Content -Raw -Encoding UTF8 $Path)
    }
    return ""
}

function Normalize-Name {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return "" }
    $v = $Value.Trim()
    $v = $v.Trim("`"", "'", " ")
    if ($v -match '^\[\[([^\]\|#]+)') { $v = $Matches[1] }
    $v = $v -replace '\.md$', ''
    return $v.Trim()
}

function Get-FrontMatterValue {
    param(
        [string]$Content,
        [string]$Key
    )
    $pattern = "(?m)^$([regex]::Escape($Key)):\s*`"?([^`"\r\n]+)`"?\s*$"
    if ($Content -match $pattern) { return $Matches[1].Trim() }
    return ""
}

function Get-WikiLinks {
    param([string]$Content)
    $result = New-Object System.Collections.Generic.List[string]
    foreach ($m in [regex]::Matches($Content, '\[\[([^\]\|#]+)')) {
        $name = Normalize-Name $m.Groups[1].Value
        if ($name) { $result.Add($name) }
    }
    return $result
}

function Get-TableRows {
    param([string]$Content)
    $rows = @()
    foreach ($line in ($Content -split "`r?`n")) {
        if ($line -notmatch '^\|') { continue }
        if ($line -match '^\|\s*-') { continue }
        $cells = $line.Trim('|') -split '\|'
        $clean = @()
        foreach ($c in $cells) { $clean += $c.Trim() }
        $rows += ,$clean
    }
    return $rows
}

function Test-NoteExists {
    param(
        [string]$Name,
        [hashtable]$NoteByBase,
        [hashtable]$NoteByFile
    )
    if ([string]::IsNullOrWhiteSpace($Name)) { return $false }
    $n = Normalize-Name $Name
    if ($NoteByBase.ContainsKey($n)) { return $true }
    if ($NoteByFile.ContainsKey($n)) { return $true }
    if ($NoteByFile.ContainsKey("$n.md")) { return $true }
    return $false
}

function Add-Issue {
    param(
        [System.Collections.Generic.List[object]]$List,
        [string]$Severity,
        [string]$Category,
        [string]$Source,
        [string]$Name,
        [string]$Detail,
        [string]$Recommendation
    )
    $List.Add([pscustomobject]@{
        Severity = $Severity
        Category = $Category
        Source = $Source
        Name = $Name
        Detail = $Detail
        Recommendation = $Recommendation
    }) | Out-Null
}

function Get-RecommendationForName {
    param(
        [string]$Name,
        [bool]$ProjectNoteExists,
        [hashtable]$NoteByBase
    )

    switch -Regex ($Name) {
        '^EXIM\.ExpenseInvoices\.Automation\.v1\.1$' { return "Needs user confirmation: keep as EXIM candidate/substream or create official project note." }
        '^PPJ\.GenAI\.Cloud\.Infrastructure\.POC\.v1\.0$' { return "Keep as approved candidate until portfolio approval." }
        '^COSTING\.AGENTIC\.PLATFORM\.v1\.1$' { return "Alias-backed by PPJ.COSTING.AGENT.PLATFORM.v1.1 if that note exists; otherwise confirm canonical note strategy." }
        '^PPJ\.COSTING\.AGENT\.PLATFORM\.v1\.1$' { return "Keep as current project note for costing platform, or add alias to COSTING.AGENTIC.PLATFORM.v1.1." }
        '^ACC\.GRN-SupplierInvoiceBot\.v2\.3$' { return "User rule says current file is ACC.GRN-SupplierInvoiceBot.v1.1; correct memory/index/registry if v2.3 note does not exist." }
        '^ACC\.GRN-SupplierInvoiceBot\.v1\.1$' { return "Treat as current ACC GRN note if it exists; align memory card if needed." }
        '^ACC\.CHICOS\.INVOICE\.RECHECK-AUDIT\.v1\.1$' { return "Correct to MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1 unless evidence proves Accounting ownership." }
        '^MER\.CHICOS\.INVOICE\.RECHECK-AUDIT\.v1\.1$' { return "Keep MER-led; create/add alias only if project note is missing." }
        '^FD\.Datamart\.v2\.2$' { return "Keep as FD Directus/QR hanger project; create missing note only if absent." }
        '^CPD\.Datamart\.v1\.1$' { return "Keep as CPD/3D Design image-search datamart; create missing note only if absent." }
        default {
            if ($ProjectNoteExists) { return "No action required." }
            return "Needs review: create missing project note, add alias, or correct memory/index/registry."
        }
    }
}

function Format-ListBlock {
    param(
        [array]$Items,
        [string]$EmptyText
    )
    if (-not $Items -or $Items.Count -eq 0) { return "- $EmptyText" }
    $lines = @()
    foreach ($i in $Items) {
        if ($i.PSObject.Properties.Name -contains "Source") {
            $lines += "- [$($i.Severity)] $($i.Category): $($i.Name) in $($i.Source) - $($i.Detail) Recommendation: $($i.Recommendation)"
        }
        elseif ($i.PSObject.Properties.Name -contains "Project") {
            $lines += "- $($i.Project) - $($i.Detail) Recommendation: $($i.Recommendation)"
        }
        else {
            $lines += "- $i"
        }
    }
    return ($lines -join "`n")
}

if (-not (Test-Path $ProjectsRoot)) { throw "03_Projects folder not found. Run this script from the vault root." }
if (-not (Test-Path $RegistryRoot)) { throw "03_Projects/_Registry folder not found. Run this script from the vault root." }

$ActiveSourcePaths = @(
    "03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md",
    "03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md",
    "03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md",
    "03_Projects/_Registry/PPJ_PROJECT_ALIAS_MAP.md",
    "03_Projects/_Registry/PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md"
)
$moduleIndexRel = "03_Projects/_Registry/PPJ_PROJECT_MODULE_INDEX.md"
if (Test-Path (Join-Path $VaultRoot $moduleIndexRel)) { $ActiveSourcePaths += $moduleIndexRel }

$ActiveSources = @()
foreach ($rel in $ActiveSourcePaths) {
    $path = Join-Path $VaultRoot $rel
    if (Test-Path $path) {
        $ActiveSources += [pscustomobject]@{ Relative = $rel; Path = $path; Content = Read-TextSafe $path }
    }
}

$ExcludedRootNames = @(
    "PROJECT_COMMAND_CENTER.md",
    "PROJECT_NAME.v1.1.md"
)

$RootProjectNotes = Get-ChildItem -Path $ProjectsRoot -File -Filter "*.md" | Where-Object {
    $ExcludedRootNames -notcontains $_.Name
}

$CommandCenterNote = Join-Path $ProjectsRoot "PROJECT_COMMAND_CENTER.md"

$NoteByBase = @{}
$NoteByFile = @{}
foreach ($note in $RootProjectNotes) {
    $NoteByBase[$note.BaseName] = $note
    $NoteByFile[$note.Name] = $note
}
if (Test-Path $CommandCenterNote) {
    $cc = Get-Item $CommandCenterNote
    $NoteByBase[$cc.BaseName] = $cc
    $NoteByFile[$cc.Name] = $cc
}

$MemoryFiles = @()
if (Test-Path $MemoryRoot) {
    $MemoryFiles = Get-ChildItem -Path $MemoryRoot -File -Filter "*.memory.md"
}

$MemoryCards = @()
foreach ($file in $MemoryFiles) {
    $content = Read-TextSafe $file.FullName
    $MemoryCards += [pscustomobject]@{
        File = $file
        BaseName = $file.BaseName -replace '\.memory$', ''
        Content = $content
        ProjectName = Get-FrontMatterValue $content "project_name"
        ProjectCode = Get-FrontMatterValue $content "project_code"
        ProjectFile = Get-FrontMatterValue $content "project_file"
        Phase = Get-FrontMatterValue $content "phase"
        Status = Get-FrontMatterValue $content "status"
        Confidence = Get-FrontMatterValue $content "confidence"
    }
}

$IndexContent = Read-TextSafe (Join-Path $RegistryRoot "PPJ_PROJECT_MEMORY_INDEX.md")
$RegistryContent = Read-TextSafe (Join-Path $RegistryRoot "PPJ_PROJECT_REGISTRY.md")
$ResourceContent = Read-TextSafe (Join-Path $RegistryRoot "PPJ_PROJECT_RESOURCE_MATRIX.md")
$AliasContent = Read-TextSafe (Join-Path $RegistryRoot "PPJ_PROJECT_ALIAS_MAP.md")
$DictionaryContent = Read-TextSafe (Join-Path $RegistryRoot "PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md")

$IndexRows = Get-TableRows $IndexContent
$IndexProjectNoteMap = @{}
foreach ($row in $IndexRows) {
    if ($row.Count -lt 3) { continue }
    if ($row[0] -eq "Project") { continue }
    $project = Normalize-Name $row[0]
    $projectNote = Normalize-Name $row[2]
    if ($project) { $IndexProjectNoteMap[$project] = $projectNote }
}

$CoverageIssues = New-Object System.Collections.Generic.List[object]
$OrphanMemoryCards = New-Object System.Collections.Generic.List[object]
$NamingDrift = New-Object System.Collections.Generic.List[object]
$ProtectedIssues = New-Object System.Collections.Generic.List[object]
$PlaceholderIssues = New-Object System.Collections.Generic.List[object]
$MarkerIssues = New-Object System.Collections.Generic.List[object]
$ReadinessIssues = New-Object System.Collections.Generic.List[object]

# A. Project note to memory coverage.
foreach ($note in $RootProjectNotes) {
    $base = $note.BaseName
    $matchingMemory = $MemoryCards | Where-Object {
        $_.BaseName -eq $base -or
        (Normalize-Name $_.ProjectName) -eq $base -or
        (Normalize-Name $_.ProjectCode) -eq $base -or
        (Normalize-Name $_.ProjectFile) -eq $base -or
        $_.ProjectFile -eq $note.Name
    }
    $missingParts = @()
    if (-not $matchingMemory) { $missingParts += "memory card" }
    if ($IndexContent -notmatch [regex]::Escape($base) -and $IndexContent -notmatch [regex]::Escape($note.Name)) { $missingParts += "memory index" }
    if ($RegistryContent -notmatch [regex]::Escape($base) -and $RegistryContent -notmatch [regex]::Escape($note.Name)) { $missingParts += "registry" }
    if ($DictionaryContent -notmatch [regex]::Escape($base) -and $DictionaryContent -notmatch [regex]::Escape($note.Name)) { $missingParts += "naming dictionary" }
    if ($missingParts.Count -gt 0) {
        $CoverageIssues.Add([pscustomobject]@{
            Project = $note.Name
            Detail = "Missing coverage: $($missingParts -join ', ')"
            Recommendation = "Add memory/index/registry/dictionary coverage or classify as alias/obsolete after approval."
        }) | Out-Null
    }
}

# B. Memory card to project note coverage.
foreach ($card in $MemoryCards) {
    $projectName = Normalize-Name $card.ProjectName
    $projectCode = Normalize-Name $card.ProjectCode
    $projectFile = Normalize-Name $card.ProjectFile
    $noteExists = $false
    if ($projectFile -and $projectFile -ne "TBD") { $noteExists = Test-NoteExists $projectFile $NoteByBase $NoteByFile }
    if (-not $noteExists -and $projectCode) { $noteExists = Test-NoteExists $projectCode $NoteByBase $NoteByFile }
    if (-not $noteExists -and $projectName) { $noteExists = Test-NoteExists $projectName $NoteByBase $NoteByFile }

    if (-not $noteExists) {
        $classification = "orphan / needs review"
        if ($card.Content -match '(?i)candidate|approved candidate') { $classification = "approved candidate" }
        elseif ([string]::IsNullOrWhiteSpace($projectFile) -or $projectFile -eq "TBD") { $classification = "new project pending project note" }
        elseif ($IndexProjectNoteMap.ContainsKey($projectCode) -and (Test-NoteExists $IndexProjectNoteMap[$projectCode] $NoteByBase $NoteByFile)) { $classification = "alias-backed" }

        $OrphanMemoryCards.Add([pscustomobject]@{
            Project = $card.File.Name
            Detail = "No direct project note found. Classification: $classification. project_file=$($card.ProjectFile)"
            Recommendation = (Get-RecommendationForName $projectCode $false $NoteByBase)
        }) | Out-Null
    }
}

# C. Naming drift.
$WatchedNames = @(
    "EXIM.ExpenseInvoices.Automation.v1.1",
    "PPJ. Expense-Invoices.v1.1",
    "COSTING.AGENTIC.PLATFORM.v1.1",
    "PPJ.COSTING.AGENT.PLATFORM.v1.1",
    "ACC.GRN-SupplierInvoiceBot.v1.1",
    "ACC.GRN-SupplierInvoiceBot.v2.3",
    "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1",
    "ACC.CHICOS.INVOICE.RECHECK-AUDIT.v1.1",
    "FD.Datamart.v2.2",
    "CPD.Datamart.v1.1"
)

$SourceReferences = @()
foreach ($src in $ActiveSources) {
    foreach ($name in $WatchedNames) {
        if ($src.Content -match [regex]::Escape($name)) {
            $SourceReferences += [pscustomobject]@{ Source = $src.Relative; Name = $name }
        }
    }
    foreach ($link in (Get-WikiLinks $src.Content)) {
        if ($link -match '\.memory$') { continue }
        if ($link -match '^PPJ_PROJECT_') { continue }
        if ($link -match '^(Decision_Driven_BRD|User_Manual_Template|System_Design_Template)$') { continue }
        $SourceReferences += [pscustomobject]@{ Source = $src.Relative; Name = $link }
    }
    foreach ($m in [regex]::Matches($src.Content, '\b[A-Z][A-Za-z0-9& ''-]*(?:\.[A-Za-z0-9& ''-]+){1,}\.v\d+\.\d+\b')) {
        $SourceReferences += [pscustomobject]@{ Source = $src.Relative; Name = (Normalize-Name $m.Value) }
    }
}

$SeenDrift = @{}
foreach ($ref in $SourceReferences) {
    $name = Normalize-Name $ref.Name
    if ([string]::IsNullOrWhiteSpace($name)) { continue }
    if ($name -match '^PPJ_PROJECT_') { continue }
    $exists = Test-NoteExists $name $NoteByBase $NoteByFile
    $key = "$($ref.Source)|$name"
    if ($SeenDrift.ContainsKey($key)) { continue }
    $SeenDrift[$key] = $true

    if (-not $exists -or $WatchedNames -contains $name) {
        $recommendation = Get-RecommendationForName $name $exists $NoteByBase
        if (-not $exists -or $name -match 'ACC\.CHICOS|ACC\.GRN-SupplierInvoiceBot\.v2\.3|COSTING\.AGENTIC|EXIM\.ExpenseInvoices') {
            Add-Issue $NamingDrift "Warning" "NamingDrift" $ref.Source $name "Project note exists: $exists" $recommendation
        }
    }
}

# D. Protected scope rules.
$FdText = ""
$CpdText = ""
$SourcingText = ""
$AiHubText = ""
$MerChicosText = ""
foreach ($src in $ActiveSources) {
    $FdText += "`n" + $src.Content
    $CpdText += "`n" + $src.Content
    $SourcingText += "`n" + $src.Content
    $AiHubText += "`n" + $src.Content
    $MerChicosText += "`n" + $src.Content
}
$fdCard = $MemoryCards | Where-Object { $_.ProjectCode -eq "FD.Datamart.v2.2" -or $_.ProjectName -eq "FD.Datamart.v2.2" } | Select-Object -First 1
$cpdCard = $MemoryCards | Where-Object { $_.ProjectCode -eq "CPD.Datamart.v1.1" -or $_.ProjectName -eq "CPD.Datamart.v1.1" } | Select-Object -First 1
$sourcingCard = $MemoryCards | Where-Object { $_.ProjectCode -eq "SCP.SOURCING.CHATBOT.v2.3" -or $_.ProjectName -eq "SCP.SOURCING.CHATBOT.v2.3" } | Select-Object -First 1
$aiHubCard = $MemoryCards | Where-Object { $_.ProjectCode -eq "PPJ.AI.Hub.v2.1" -or $_.ProjectName -eq "PPJ.AI.Hub.v2.1" } | Select-Object -First 1
$merChicosCard = $MemoryCards | Where-Object { $_.ProjectCode -eq "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1" -or $_.ProjectName -eq "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1" } | Select-Object -First 1
if ($fdCard) { $FdText += "`n" + $fdCard.Content }
if ($cpdCard) { $CpdText += "`n" + $cpdCard.Content }
if ($sourcingCard) { $SourcingText += "`n" + $sourcingCard.Content }
if ($aiHubCard) { $AiHubText += "`n" + $aiHubCard.Content }
if ($merChicosCard) { $MerChicosText += "`n" + $merChicosCard.Content }

foreach ($term in @("Directus", "QR", "hanger")) {
    if ($FdText -notmatch [regex]::Escape($term)) { Add-Issue $ProtectedIssues "Error" "FD Scope" "FD active text" "FD.Datamart.v2.2" "Missing required term: $term" "Add/restore FD Directus QR hanger meaning." }
}
if ($FdText -notmatch '(?i)separate from CPD|not CPD|FD and CPD|FD / CPD') { Add-Issue $ProtectedIssues "Error" "FD Scope" "FD active text" "FD.Datamart.v2.2" "Missing separation from CPD" "Add explicit FD/CPD separation rule." }
foreach ($line in ($FdText -split "`r?`n")) {
    if ($line -match 'FD' -and $line -match '(?i)image search|3D sample library|Chi Trang|3D Design|CPD business canonical' -and $line -notmatch '(?i)not|do not|must not|separate|unless') {
        Add-Issue $ProtectedIssues "Error" "FD Forbidden Scope" "FD active text" "FD.Datamart.v2.2" $line.Trim() "Remove CPD/image-search/3D Design wording from FD scope."
    }
}

foreach ($term in @("CPD", "3D", "image search")) {
    if ($CpdText -notmatch [regex]::Escape($term)) { Add-Issue $ProtectedIssues "Error" "CPD Scope" "CPD active text" "CPD.Datamart.v1.1" "Missing required term: $term" "Add/restore CPD 3D Design image-search meaning." }
}
if ($CpdText -notmatch '(?i)visual sample|sample library') { Add-Issue $ProtectedIssues "Error" "CPD Scope" "CPD active text" "CPD.Datamart.v1.1" "Missing visual sample or sample library meaning" "Add CPD visual sample asset scope." }
if ($CpdText -notmatch '(?i)separate from FD|not FD|CPD and FD|FD / CPD') { Add-Issue $ProtectedIssues "Error" "CPD Scope" "CPD active text" "CPD.Datamart.v1.1" "Missing separation from FD" "Add explicit FD/CPD separation rule." }
foreach ($line in ($CpdText -split "`r?`n")) {
    if ($line -match 'CPD' -and $line -match '(?i)Directus hanger|hanger QR|FD fabric hanger|QR hanger' -and $line -notmatch '(?i)not|do not|must not|separate|unless') {
        Add-Issue $ProtectedIssues "Error" "CPD Forbidden Scope" "CPD active text" "CPD.Datamart.v1.1" $line.Trim() "Remove FD/Directus hanger QR wording from CPD scope."
    }
}

if ($SourcingText -notmatch 'SCP\.SOURCING\.CHATBOT\.v2\.3' -or $SourcingText -notmatch '(?i)consolidated|do not split|not split') {
    Add-Issue $ProtectedIssues "Error" "Sourcing Scope" "Sourcing active text" "SCP.SOURCING.CHATBOT.v2.3" "Missing consolidated/do-not-split rule" "Restore sourcing consolidation rule."
}
if ($AiHubText -notmatch '(?i)hub' -or $AiHubText -notmatch '(?i)not.*(replacement|merge|absorb)|do not.*(merge|absorb)') {
    Add-Issue $ProtectedIssues "Warning" "AI Hub Scope" "AI Hub active text" "PPJ.AI.Hub.v2.1" "Hub/not-merge rule not clearly present" "Keep AI Hub as hub/governance layer only."
}
if ($MerChicosText -match 'ACC\.CHICOS\.INVOICE\.RECHECK-AUDIT\.v1\.1') {
    Add-Issue $ProtectedIssues "Error" "MER Chico's Scope" "MER active text" "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1" "ACC.CHICOS reference found in active source" "Correct to MER.CHICOS unless evidence proves Accounting ownership."
}
foreach ($line in ($MerChicosText -split "`r?`n")) {
    if ($line -match '(?i)purely Accounting' -and $line -notmatch '(?i)do not|must not|unless|not classify') {
        Add-Issue $ProtectedIssues "Error" "MER Chico's Scope" "MER active text" "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1" "Purely Accounting wording found: $($line.Trim())" "Keep MER-led unless evidence proves otherwise."
    }
}

$accGrnV11Exists = Test-NoteExists "ACC.GRN-SupplierInvoiceBot.v1.1" $NoteByBase $NoteByFile
$accGrnV23Exists = Test-NoteExists "ACC.GRN-SupplierInvoiceBot.v2.3" $NoteByBase $NoteByFile
$activeAll = (($ActiveSources | ForEach-Object { $_.Content }) -join "`n") + "`n" + (($MemoryCards | ForEach-Object { $_.Content }) -join "`n")
if ($activeAll -match 'ACC\.GRN-SupplierInvoiceBot\.v2\.3' -and -not $accGrnV23Exists -and $accGrnV11Exists) {
    Add-Issue $ProtectedIssues "Error" "ACC GRN Version" "Active memory/registry" "ACC.GRN-SupplierInvoiceBot.v2.3" "v2.3 referenced while current v1.1 project note exists" "Correct memory/index/registry to v1.1."
}

# E. Placeholder and test artifact check.
$PlaceholderFiles = @()
$PlaceholderFiles += $ActiveSources | ForEach-Object { [pscustomobject]@{ Relative = $_.Relative; Path = $_.Path; Content = $_.Content } }
$PlaceholderFiles += $MemoryCards | ForEach-Object { [pscustomobject]@{ Relative = "03_Projects/_Registry/Project_Memory/$($_.File.Name)"; Path = $_.File.FullName; Content = $_.Content } }
$PlaceholderFiles += $RootProjectNotes | ForEach-Object { [pscustomobject]@{ Relative = "03_Projects/$($_.Name)"; Path = $_.FullName; Content = Read-TextSafe $_.FullName } }
$IntakeRoot = Join-Path $RegistryRoot "Project_Update_Intake"
if (Test-Path $IntakeRoot) {
    $PlaceholderFiles += Get-ChildItem -Path $IntakeRoot -File -Filter "*.md" | ForEach-Object { [pscustomobject]@{ Relative = "03_Projects/_Registry/Project_Update_Intake/$($_.Name)"; Path = $_.FullName; Content = Read-TextSafe $_.FullName } }
}
$ProposalRoot = Join-Path $RegistryRoot "Project_Update_Proposals"
if (Test-Path $ProposalRoot) {
    $PlaceholderFiles += Get-ChildItem -Path $ProposalRoot -File -Filter "*.md" | ForEach-Object { [pscustomobject]@{ Relative = "03_Projects/_Registry/Project_Update_Proposals/$($_.Name)"; Path = $_.FullName; Content = Read-TextSafe $_.FullName } }
}

$PlaceholderPatterns = @(
    '\bPROJECT_NAME\b',
    '\bDEPARTMENT\b',
    '\bOBJECT\b',
    '\bPURPOSE\b',
    '\bOUTCOME\b',
    'PASTE UPDATE HERE',
    'INTAKE_FILE\.md',
    '\bCLUSTER\b'
)
foreach ($pf in $PlaceholderFiles) {
    foreach ($pattern in $PlaceholderPatterns) {
        $lineNumber = 0
        foreach ($line in ($pf.Content -split "`r?`n")) {
            $lineNumber++
            if ($line -cnotmatch $pattern) { continue }
            $isAllowedTemplateExplanation = $false
            if ($pattern -eq '\bOBJECT\b' -and $line -match '\[DEPT/DOMAIN\]\.\[OBJECT\]') { $isAllowedTemplateExplanation = $true }
            if ($pattern -eq '\bCLUSTER\b' -and $line -match '(?i)cluster:|Portfolio Group|Cluster \|') { $isAllowedTemplateExplanation = $true }
            if ($pattern -eq '\bPURPOSE\b' -and $line -match '(?i)Purpose:') { $isAllowedTemplateExplanation = $true }
            if ($pattern -eq '\bOUTCOME\b' -and $line -match '(?i)Outcome\s*[:|]') { $isAllowedTemplateExplanation = $true }
            if ($isAllowedTemplateExplanation) { continue }
            Add-Issue $PlaceholderIssues "Error" "Placeholder" $pf.Relative $pattern "Placeholder token found in active file at line $lineNumber" "Clean/archive placeholder artifact or patch source script after approval."
        }
    }
}

# F. Marker compliance.
foreach ($note in $RootProjectNotes) {
    $content = Read-TextSafe $note.FullName
    $hasStart = $content -match '<!--\s*PPJ_PROJECT_KNOWLEDGE_START\s*-->'
    $hasEnd = $content -match '<!--\s*PPJ_PROJECT_KNOWLEDGE_END\s*-->'
    if (($hasStart -and -not $hasEnd) -or ($hasEnd -and -not $hasStart)) {
        Add-Issue $MarkerIssues "Error" "MarkerCompliance" "03_Projects/$($note.Name)" $note.Name "Managed marker start/end imbalance" "Restore both PPJ_PROJECT_KNOWLEDGE markers or remove incomplete block after review."
    }
    if ($content -match '(?i)generated project knowledge content|generated content start|generated content end') {
        Add-Issue $MarkerIssues "Error" "MarkerCompliance" "03_Projects/$($note.Name)" $note.Name "Old/generated marker wording found" "Replace with PPJ_PROJECT_KNOWLEDGE_START/END only."
    }
    if ($Strict -and -not $hasStart -and -not $hasEnd) {
        Add-Issue $MarkerIssues "Warning" "MarkerCompliance" "03_Projects/$($note.Name)" $note.Name "No managed project knowledge block" "Add managed block only when project note is approved for managed updates."
    }
}

# G. Auto-update readiness.
$RequiredPaths = @(
    "03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md",
    "03_Projects/_Registry/PPJ_PROJECT_UPDATE_LEDGER.md",
    "03_Projects/_Registry/PPJ_PROJECT_REGISTRATION_PROTOCOL.md",
    "03_Projects/_Registry/Project_Update_Intake",
    "03_Projects/_Registry/Project_Update_Proposals",
    "03_Projects/_Registry/Project_Memory"
)
foreach ($rel in $RequiredPaths) {
    if (-not (Test-Path (Join-Path $VaultRoot $rel))) {
        Add-Issue $ReadinessIssues "Error" "AutoUpdateReadiness" $rel $rel "Required path missing" "Create required path after approval."
    }
}

$RequiredScripts = @(
    "scripts/Create-PPJProjectUpdateIntake.ps1",
    "scripts/Update-PPJProjectKnowledgeFromIntake.ps1",
    "scripts/Register-PPJProject.ps1",
    "scripts/Cleanup-PPJPlaceholderProjectArtifacts.ps1"
)
foreach ($rel in $RequiredScripts) {
    if (-not (Test-Path (Join-Path $VaultRoot $rel))) {
        Add-Issue $ReadinessIssues "Error" "AutoUpdateReadiness" $rel $rel "Required script missing" "Create/restore script after approval."
    }
}

foreach ($rel in $RequiredScripts) {
    $path = Join-Path $VaultRoot $rel
    if (-not (Test-Path $path)) { continue }
    $content = Read-TextSafe $path
    $hasGuardSignal = ($content -match '(?i)placeholder|refusing|guard|PROJECT_NAME|PASTE UPDATE HERE|INTAKE_FILE') -and ($content -match '(?i)throw|exit 1')
    if (-not $hasGuardSignal) {
        Add-Issue $ReadinessIssues "Warning" "AutoUpdateReadiness" $rel $rel "Placeholder guard not clearly detected" "Patch placeholder hard-fail guard before using Apply workflows."
    }
}

$coverageErrorCount = @($CoverageIssues.ToArray() | Where-Object { $_.Severity -eq "Error" }).Count
$orphanErrorCount = @($OrphanMemoryCards.ToArray() | Where-Object { $_.Detail -match 'orphan' }).Count
$namingErrorCount = @($NamingDrift.ToArray() | Where-Object { $_.Severity -eq "Error" }).Count
$protectedErrorCount = @($ProtectedIssues.ToArray() | Where-Object { $_.Severity -eq "Error" }).Count
$placeholderErrorCount = $PlaceholderIssues.Count
$markerErrorCount = @($MarkerIssues.ToArray() | Where-Object { $_.Severity -eq "Error" }).Count
$readinessErrorCount = @($ReadinessIssues.ToArray() | Where-Object { $_.Severity -eq "Error" }).Count
$criticalCount = [int]$coverageErrorCount + [int]$orphanErrorCount + [int]$namingErrorCount + [int]$protectedErrorCount + [int]$placeholderErrorCount + [int]$markerErrorCount + [int]$readinessErrorCount

$coverageWarningCount = $CoverageIssues.Count
$orphanWarningCount = $OrphanMemoryCards.Count
$namingWarningCount = $NamingDrift.Count
$protectedWarningCount = @($ProtectedIssues.ToArray() | Where-Object { $_.Severity -eq "Warning" }).Count
$markerWarningCount = @($MarkerIssues.ToArray() | Where-Object { $_.Severity -eq "Warning" }).Count
$readinessWarningCount = @($ReadinessIssues.ToArray() | Where-Object { $_.Severity -eq "Warning" }).Count
$warningCount = [int]$coverageWarningCount + [int]$orphanWarningCount + [int]$namingWarningCount + [int]$protectedWarningCount + [int]$markerWarningCount + [int]$readinessWarningCount

$ReadinessStatus = "Ready"
if ($criticalCount -gt 0) { $ReadinessStatus = "Not ready" }
elseif ($warningCount -gt 0) { $ReadinessStatus = "Ready with warnings" }

$RequiredFixes = @()
if ($CoverageIssues.Count -gt 0) { $RequiredFixes += "Resolve missing root project coverage or classify aliases/obsolete notes." }
if ($OrphanMemoryCards.Count -gt 0) { $RequiredFixes += "Classify memory cards without direct project notes." }
if ($NamingDrift.Count -gt 0) { $RequiredFixes += "Review naming drift and update aliases/registry/memory after approval." }
if ($ProtectedIssues.Count -gt 0) { $RequiredFixes += "Fix protected scope conflicts before using auto-update agent." }
if ($PlaceholderIssues.Count -gt 0) { $RequiredFixes += "Clean active placeholder artifacts before Apply workflows." }
if ($MarkerIssues.Count -gt 0) { $RequiredFixes += "Fix marker compliance before managed project-note updates." }
if ($ReadinessIssues.Count -gt 0) { $RequiredFixes += "Restore missing readiness components or patch placeholder guards." }
if ($RequiredFixes.Count -eq 0) { $RequiredFixes += "No required fixes detected." }

$RecommendedNextAction = "Use auto-update agent only after resolving Not ready errors."
if ($ReadinessStatus -eq "Ready") { $RecommendedNextAction = "Proceed with auto-update DryRun on a real intake file; do not use Apply until review." }
elseif ($ReadinessStatus -eq "Ready with warnings") { $RecommendedNextAction = "Review warnings, then run a small auto-update DryRun with no Canvas/project note changes." }

$ReportDate = Get-Date -Format "yyyyMMdd"
$ReportPath = Join-Path $ReportsRoot "PROJECT_MEMORY_CONSISTENCY_AUDIT_$ReportDate.md"

$Report = @"
# Project Memory Consistency Audit - $ReportDate

## Executive Summary

- Mode: DryRun / audit only
- Strict mode: $Strict
- Auto-update readiness: $ReadinessStatus
- Root project count: $($RootProjectNotes.Count)
- Memory card count: $($MemoryCards.Count)
- Missing coverage findings: $($CoverageIssues.Count)
- Memory cards without project notes: $($OrphanMemoryCards.Count)
- Naming drift findings: $($NamingDrift.Count)
- Protected scope issues: $($ProtectedIssues.Count)
- Placeholder findings: $($PlaceholderIssues.Count)
- Marker issues: $($MarkerIssues.Count)
- Auto-update readiness issues: $($ReadinessIssues.Count)

## Root Project Count

$($RootProjectNotes.Count)

Command center classified separately: $(Test-Path $CommandCenterNote)

## Memory Card Count

$($MemoryCards.Count)

## Coverage Summary

Missing coverage findings: $($CoverageIssues.Count)

## Missing Memory Cards

$(Format-ListBlock $CoverageIssues "No missing root project coverage detected.")

## Memory Cards Without Project Notes

$(Format-ListBlock $OrphanMemoryCards "No orphan/pending memory cards detected.")

## Naming Drift Findings

$(Format-ListBlock $NamingDrift "No naming drift findings detected.")

## Protected Scope Validation

$(Format-ListBlock $ProtectedIssues "No protected scope issues detected.")

## Placeholder Check

$(Format-ListBlock $PlaceholderIssues "No active placeholder findings detected.")

## Marker Compliance

$(Format-ListBlock $MarkerIssues "No marker compliance issues detected.")

## Auto-Update Readiness

Status: $ReadinessStatus

$(Format-ListBlock $ReadinessIssues "All required auto-update files/folders/scripts detected and guards appear present.")

## Required Fixes

$(($RequiredFixes | ForEach-Object { "- $_" }) -join "`n")

## Recommended Next Actions

- $RecommendedNextAction
- Do not update Canvas during consistency fixes.
- Do not modify project notes until marker compliance and source-of-truth conflicts are resolved.

## Approval Checklist

- [ ] Review missing memory coverage.
- [ ] Review memory cards without project notes.
- [ ] Approve any alias additions or registry corrections.
- [ ] Confirm ACC.GRN canonical version before changing memory/index.
- [ ] Confirm EXIM project-note strategy.
- [ ] Confirm whether candidate projects should become official root notes.
- [ ] Re-run this audit in DryRun.
"@

Write-Host "PPJ Project Memory Consistency Audit"
Write-Host "Mode: DryRun / audit only"
Write-Host "Strict: $Strict"
Write-Host "Root project count: $($RootProjectNotes.Count)"
Write-Host "Memory card count: $($MemoryCards.Count)"
Write-Host "Missing memory/coverage findings: $($CoverageIssues.Count)"
Write-Host "Orphan/pending memory cards: $($OrphanMemoryCards.Count)"
Write-Host "Naming drift findings: $($NamingDrift.Count)"
Write-Host "Protected scope issues: $($ProtectedIssues.Count)"
Write-Host "Placeholder findings: $($PlaceholderIssues.Count)"
Write-Host "Marker issues: $($MarkerIssues.Count)"
Write-Host "Auto-update readiness: $ReadinessStatus"
Write-Host "Recommended next action: $RecommendedNextAction"

if ($CoverageIssues.Count -gt 0) {
    Write-Host ""
    Write-Host "Missing coverage preview:"
    $CoverageIssues | Select-Object -First 10 | ForEach-Object { Write-Host "- $($_.Project): $($_.Detail)" }
}
if ($OrphanMemoryCards.Count -gt 0) {
    Write-Host ""
    Write-Host "Memory cards without project notes preview:"
    $OrphanMemoryCards | Select-Object -First 10 | ForEach-Object { Write-Host "- $($_.Project): $($_.Detail)" }
}
if ($NamingDrift.Count -gt 0) {
    Write-Host ""
    Write-Host "Naming drift preview:"
    $NamingDrift | Select-Object -First 10 | ForEach-Object { Write-Host "- $($_.Name) in $($_.Source): $($_.Detail)" }
}
if ($ProtectedIssues.Count -gt 0) {
    Write-Host ""
    Write-Host "Protected scope issues preview:"
    $ProtectedIssues | Select-Object -First 10 | ForEach-Object { Write-Host "- [$($_.Severity)] $($_.Name): $($_.Detail)" }
}
if ($PlaceholderIssues.Count -gt 0) {
    Write-Host ""
    Write-Host "Placeholder findings preview:"
    $PlaceholderIssues | Select-Object -First 10 | ForEach-Object { Write-Host "- $($_.Source): $($_.Name)" }
}
if ($MarkerIssues.Count -gt 0) {
    Write-Host ""
    Write-Host "Marker issues preview:"
    $MarkerIssues | Select-Object -First 10 | ForEach-Object { Write-Host "- $($_.Source): $($_.Detail)" }
}
if ($ReadinessIssues.Count -gt 0) {
    Write-Host ""
    Write-Host "Auto-update readiness issues preview:"
    $ReadinessIssues | Select-Object -First 10 | ForEach-Object { Write-Host "- [$($_.Severity)] $($_.Source): $($_.Detail)" }
}

if ($ExportReport) {
    if (-not (Test-Path $ReportsRoot)) {
        New-Item -ItemType Directory -Path $ReportsRoot -Force | Out-Null
    }
    Set-Content -Path $ReportPath -Value $Report -Encoding UTF8
    Write-Host "Report exported: $ReportPath"
}
else {
    Write-Host "Report not exported. Re-run with -ExportReport to create: $ReportPath"
}

if ($Strict -and $criticalCount -gt 0) {
    exit 2
}

exit 0