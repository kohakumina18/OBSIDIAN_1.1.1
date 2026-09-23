param(
    [switch]$DryRun,
    [switch]$Apply,
    [switch]$Force,
    [switch]$UpdateDomainModel,
    [switch]$UpdateRegistry,
    [switch]$UpdateMemory,
    [switch]$UpdateProjectNotes,
    [switch]$UpdateAliasMap,
    [switch]$UpdateResourceMatrix,
    [switch]$CreateDomainCanvas,
    [switch]$CreateMissingOfficialNotes,
    [switch]$RenameCanonicalFiles
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if ($DryRun -and $Apply) { throw "Use only one mode: -DryRun or -Apply." }
if (-not $Apply) { $DryRun = $true }

$VaultRoot = (Get-Location).ProviderPath
$Today = Get-Date -Format "yyyy-MM-dd"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$DateStamp = Get-Date -Format "yyyyMMdd"

$RegistryDir = Join-Path $VaultRoot "03_Projects\_Registry"
$MemoryDir = Join-Path $RegistryDir "Project_Memory"
$CanvasDir = Join-Path $VaultRoot "03_Projects\Canvas"
$ReportDir = Join-Path $VaultRoot "10_Reports"
$AuditDir = Join-Path $VaultRoot "99_Attachments\Audit"
$BackupRoot = Join-Path $AuditDir "Domain_Model_Update_Backup\$Stamp"
$CanvasBackupRoot = Join-Path $VaultRoot "99_Attachments\Canvas_Backup\$Stamp"

$AgentPath = Join-Path $VaultRoot "AGENTS.md"
$DomainModelPath = Join-Path $RegistryDir "PPJ_PORTFOLIO_DOMAIN_MODEL.md"
$DomainMatrixPath = Join-Path $RegistryDir "PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md"
$NamingDictionaryPath = Join-Path $RegistryDir "PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md"
$MemoryIndexPath = Join-Path $RegistryDir "PPJ_PROJECT_MEMORY_INDEX.md"
$RegistryPath = Join-Path $RegistryDir "PPJ_PROJECT_REGISTRY.md"
$ResourceMatrixPath = Join-Path $RegistryDir "PPJ_PROJECT_RESOURCE_MATRIX.md"
$AliasMapPath = Join-Path $RegistryDir "PPJ_PROJECT_ALIAS_MAP.md"
$DomainCanvasPath = Join-Path $CanvasDir "PPJ_Domain_Encapsulation.canvas"
$OperationLogPath = Join-Path $AuditDir "DOMAIN_MODEL_UPDATE_LOG_$Stamp.md"
$FinalReportPath = Join-Path $ReportDir "DOMAIN_MODEL_AND_CANVAS_UPDATE_REPORT_$DateStamp.md"

$AllowedLifecycle = @(
    "Analysis",
    "Design",
    "Development",
    "UAT / Stabilization",
    "Production / Support",
    "Maintenance",
    "On Hold / Pending Decision",
    "Closed / Completed",
    "Canceled / Closed",
    "Hardware Trial / Feasibility Assessment",
    "PoC / Sample Data Preparation",
    "Final Stabilization / Pending Acceptance"
)

function New-Domain {
    param([string]$Name, [string]$Capability)
    [pscustomobject]@{ Name = $Name; Capability = $Capability }
}

function New-Project {
    param(
        [string]$CanonicalCode,
        [string]$CurrentFile,
        [string]$PrimaryDomain,
        [string]$PrimaryCapability,
        [string]$SecondaryDomains,
        [string]$Lifecycle,
        [string]$Progress,
        [string]$Gate,
        [string]$OwnerUsers,
        [string]$Outcome,
        [string]$Confidence,
        [string[]]$Aliases,
        [string[]]$DoNotDrift
    )
    [pscustomobject]@{
        CanonicalCode = $CanonicalCode
        CurrentFile = $CurrentFile
        PrimaryDomain = $PrimaryDomain
        PrimaryCapability = $PrimaryCapability
        SecondaryDomains = $SecondaryDomains
        Lifecycle = $Lifecycle
        Progress = $Progress
        Gate = $Gate
        OwnerUsers = $OwnerUsers
        Outcome = $Outcome
        Confidence = $Confidence
        Aliases = $Aliases
        DoNotDrift = $DoNotDrift
    }
}

$Domains = @(
    New-Domain "External Collaboration" "Academic partnership, innovation, prototype, talent pipeline"
    New-Domain "QC / TQM" "Quality inspection, defect detection, traceability"
    New-Domain "Sourcing / Purchasing" "Supplier/material intelligence and purchasing transactions"
    New-Domain "Merchandising" "Costing, quotation, market intelligence, customer workflows"
    New-Domain "Production + Wash" "Factory execution, production data, wash operations"
    New-Domain "Finance / Accounting" "Financial analysis, reporting, invoices, GRN"
    New-Domain "Internal Chatbot & AI Platforms" "AI access, agent orchestration, helpdesk, shared platforms"
    New-Domain "HR" "Employee, payroll, BHXH and HR-sensitive workflows"
    New-Domain "Fabric / Textiles Technique" "Fabric, pattern, BOM, technical knowledge, 3D and scanning"
)

$Projects = @(
    New-Project "PPJ.UIT.ACADEMIC.COLLABORATION.v1.1" "PPJ.UIT.ACADEMIC.COLLABORATION.v1.1.md" "External Collaboration" "Academic partnership, innovation, prototype, talent pipeline" "Education, Innovation, Talent Pipeline" "Analysis" "TBD" "Partnership Follow-up / Confirmed Direction" "PPJ / UIT / AISC / BA Coordination" "Build innovation, mentoring, internship, and academic prototype pipeline." "Strong" @("PPJ x UIT Academic Collaboration", "UIT partnership", "AISC") @("Keep as academic partnership, not vendor solution.")

    New-Project "PPJxQSee.AI" "PPJxQSee.ai.md" "QC / TQM" "Quality inspection, defect detection, traceability" "Factory, Production, MER, Customer" "PoC / Sample Data Preparation" "TBD" "NDA approved / PoC scope definition" "QC / Production / Khoa" "Define QC/production AI inspection PoC scope, data requirement, and success criteria." "Strong" @("PPJxQSee.ai", "QSee.ai", "QSee") @("Primary domain is QC / TQM, not External Collaboration.")
    New-Project "QC.Primo1D.RFID.Thread.v1.0" "PPJ XPrimo1D RFID Thread.md" "QC / TQM" "Quality inspection, defect detection, traceability" "MER, Customer, Factory" "Hardware Trial / Feasibility Assessment" "TBD" "Pre-contact / Internal Alignment" "QC / Production / Khoa" "Explore RFID thread feasibility for product traceability and identification." "Strong" @("PPJ XPrimo1D RFID Thread", "Primo1D RFID Thread", "RFID Thread") @("Keep as traceability/QC feasibility, not general vendor project.")

    New-Project "SCP.SOURCING.CHATBOT.v2.3" "SCP.SOURCING.CHATBOT.v2.3.md" "Sourcing / Purchasing" "Sourcing intelligence: supplier, material, sample, search, intelligence" "Data Governance, AI Chatbot, Supplier Data" "UAT / Stabilization" "80%" "UAT / Iterative Improvement" "Sourcing users / Khoa / Huy / Linh / Nghia" "Enable governed supplier, material, fabric, trims, and sample lookup through sourcing chatbot." "Strong" @("Sourcing Chatbot", "SCP.Sourcing-Chatbot.ver2", "Sourcing VER2") @("Do not split sourcing into separate project notes without approval.", "Do not mix sourcing intelligence with purchasing transaction automation.")
    New-Project "PUR.Adhoc.Indent.South.v1.0" "PUR.Adhoc Indent mien Nam.md" "Sourcing / Purchasing" "Purchasing transaction: regional adhoc indent workflow" "WFX, Purchasing Operations" "Production / Support" "TBD" "Production / Support" "Purchasing South / Uyen / Nam" "Support South-region adhoc indent processing and operational exceptions." "Strong" @("PUR.Adhoc Indent mien Nam", "Adhoc Indent mien Nam", "Adhoc Indent") @("Keep South-region purchasing scope unless expansion is confirmed.")
    New-Project "PUR.Material.Allocation.v1.1" "PUR.Material.Allocation.v1.1.md" "Sourcing / Purchasing" "Purchasing transaction: allocation, validation, review" "WFX, Inventory, Production" "Development" "50%" "Blocked by WFX dependency" "Purchasing / Khoa / Uyen / Nam / Phat" "Support material allocation decisions and reduce manual processing with WFX-aware validation." "Strong" @("Material Allocation", "Material Allocation Automation") @("Keep WFX dependency visible.")
    New-Project "PUR.Inventory.Report.v1.0" "PUR.Inventory Report.md" "Sourcing / Purchasing" "Purchasing transaction/reporting: inventory visibility" "Inventory, Reporting, WFX" "Production / Support" "TBD" "Maintenance and Support" "Purchasing / Uyen / Nam" "Improve purchasing inventory visibility and reduce repeated reporting work." "Strong" @("PUR.Inventory Report", "Purchasing Inventory Report", "Inventory Report") @("Confirm users, data source, and refresh schedule before expanding scope.")
    New-Project "PUR.GDI.Automation.v1.0" "PUR.GDI Automation.md" "Sourcing / Purchasing" "Purchasing transaction: GDI creation automation" "WFX, Purchasing Operations" "On Hold / Pending Decision" "TBD" "Blocked / Scope Reassessment" "Purchasing / Uyen / Nam / Phat" "Automate GDI workflow after input standardization and WFX feasibility are resolved." "Strong" @("PUR.GDI Automation", "PUR.GDI.Automation", "GDI Automation") @("Do not mark production while WFX dependency remains.")
    New-Project "PUR.HM.LabelO.Processing.Automation.v1.0" "PUR.H&M Label-O Processing.md" "Sourcing / Purchasing" "Purchasing/customer-specific transaction automation" "Customer, Production, QC" "On Hold / Pending Decision" "TBD" "On Hold / Delayed" "Purchasing / Uyen / Khoa / Nam" "Support H&M Label-O processing if requirements and blockers are confirmed." "Strong" @("PUR.H&M Label-O Processing", "H&M Label-O Processing", "H&M Label-O") @("Do not mark active if still delayed.")

    New-Project "COSTING.AGENTIC.PLATFORM.v1.1" "PPJ.COSTING.AGENT.PLATFORM.v1.1.md" "Merchandising" "Costing, quotation, market intelligence, customer workflows" "Technical, Sew, Wash, Fabric, Finance" "Analysis" "TBD" "Data Acquisition / Sew-first Implementation" "MER / Khoa / Lam / Uyen" "Route customer requests through costing, technical, sew, wash, cut, and historical costing agents." "Strong" @("PPJ.COSTING.AGENT.PLATFORM.v1.1", "MER Costing Intelligence", "Costing Intelligence") @("Keep as strategic platform, not simple calculator.")
    New-Project "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1" "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1.md" "Merchandising" "Costing, quotation, market intelligence, customer workflows" "Accounting, Customer, Invoice Data" "UAT / Stabilization" "TBD" "Stabilize" "MER / Khoa / Hien" "Standardize and speed up Chico's invoice/costing checking and audit logic." "Strong" @("MER.Chico's.Costing-Invoice.Recheck-Audit.v1.1", "Chico's audit", "Chico's recheck") @("Do not classify as Finance; primary business scope is MER costing/commercial logic.")
    New-Project "MER.MARKET.INTELLIGENCE.v1.1" "E-commerce Market Intelligence.md" "Merchandising" "Costing, quotation, market intelligence, customer workflows" "External Data, Product, Fabric, Customer Signals" "Analysis" "TBD" "Multi-source Data Follow-up" "MER / Khoa / Phat / Nghia" "Identify product, fabric, color, fit, and market opportunities using internal and external signals." "Strong" @("MER.MARKET.INTELLIGENCE.v5.5", "E-commerce Market Intelligence", "Market Intelligence") @("Use v1.1 as canonical, preserve v5.5 as alias only.")
    New-Project "MER.PO.Commit.v1.1" "MER.PO-Commit.md" "Merchandising" "Costing, quotation, market intelligence, customer workflows" "Purchasing, Customer, Packing List" "Closed / Completed" "TBD" "Closed / Production Support" "MER / Uyen / Lam" "Preserve PO/customer commitment workflow support and reopen only if enhancement is approved." "Strong" @("MER.PO-Commit", "MER.PO Commit", "PO Commit") @("Closed lifecycle remains inside Merchandising domain.")

    New-Project "PROD.IOT.CHuyenTreo.v1.0" "PROD.IOT.CHuyenTreo_1.md" "Production + Wash" "Factory execution, production data, wash operations" "IoT, Factory, Dashboard" "Development" "50%" "Development" "Production / Factory / Khoa / Linh" "Improve production line visibility through Chuyen Treo IoT monitoring/dashboard." "Strong" @("PROD.IOT.CHuyenTreo_1", "Chuyen Treo IoT Dashboard", "Chuyen treo ver1") @("Confirm metrics and device/data source.")
    New-Project "PROD.COWASH.v2.0" "PROD.COWASH.md" "Production + Wash" "Factory execution, production data, wash operations" "R&D Wash, Factory, Operational Data" "On Hold / Pending Decision" "TBD" "Re-scope / Source API unclear" "Production / Wash / Khoa / Linh" "Clarify operational wash data, machine, output, delay, and rework tracking/reporting." "Strong" @("PROD.COWASH", "COWASH ver2", "Cowash VER2") @("Do not merge with Wash Sampling Portal.")
    New-Project "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1" "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1.md" "Production + Wash" "Factory execution, production data, wash operations" "R&D Wash, Portal, Sampling Workflow" "Analysis" "TBD" "New Booking / Analysis" "R&D Wash / Khoa / Huy / Hien" "Centralize wash sampling requests, trials, results, approval, attachments, status, and history." "Strong" @("WASH.SAMPLING.MGMT.PORTAL.v1.1", "RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1") @("Do not merge with Cowash or CPD/FD datamarts.")

    New-Project "FIN.AI.FINANCE.MANAGEMENT.v1.1" "FIN.AI.FINANCE.MANAGEMENT.v1.1.md" "Finance / Accounting" "Financial analysis, reporting, invoices, GRN" "Data, IT, Sales, Management" "Analysis" "TBD" "Discovery / BRD / Strategic Program" "Finance / Accounting / Management / Khoa" "Prepare finance AI management discovery for cash flow, reporting, forecasting, and management insight." "Strong" @("AI-assisted Finance Management", "Finance AI Analytics") @("Do not move to development before discovery and permission confirmation.")
    New-Project "PPJ.ExpenseInvoices.v1.1" "PPJ. Expense-Invoices.v1.1.md" "Finance / Accounting" "Financial analysis, reporting, invoices, GRN" "EXIM, ERP, Department Mapping" "UAT / Stabilization" "TBD" "Cross-department Expansion" "Accounting / Uyen / Nam / Phat" "Complete accounting mapping before expanding expense invoice automation." "Strong" @("PPJ. Expense-Invoices.v1.1", "Accounting Expense Invoices") @("Do not create v2 without approval.")
    New-Project "ACC.GRN-SupplierInvoiceBot.v2.3" "ACC.GRN-SupplierInvoiceBot.v2.3.md" "Finance / Accounting" "Financial analysis, reporting, invoices, GRN" "WFX, Supplier Invoice, Accounting" "Production / Support" "TBD" "Maintenance and Support" "Accounting / Uyen / Hien / Khoa" "Maintain Accounting GRN and supplier invoice bot, exception handling, logs, and support." "Strong" @("ACC.GRN-SupplierInvoiceBot.v1.1", "GRN Supplier Invoice Bot") @("Current official canonical code is v2.3, v1.1 is alias only.")
    New-Project "PPJ.InvoiceDownloader.v1.2" "PPJ.Invoice Downloader.v1.2.md" "Finance / Accounting" "Financial analysis, reporting, invoices, GRN" "EXIM, Purchasing, API, E-invoice" "Production / Support" "TBD" "Business Adoption" "Accounting / EXIM / Uyen / Nam / Phat" "Download, merge, log, permission, retry, and fallback for e-invoice workflows." "Strong" @("PPJ.Invoice Downloader.v1.2", "SYS.Invoices.Download & Merging", "Invoice Downloader") @("Shared technical utility but Finance / Accounting primary domain.")

    New-Project "PPJ.AI.Hub.v2.1" "PPJ.AI.Hub.v2.1.md" "Internal Chatbot & AI Platforms" "AI access, agent orchestration, helpdesk, shared platforms" "Management, Reporting, Internal Tools" "Production / Support" "TBD" "Platform / Internal Hub" "AI Team / Management / Reporting / Khoa / Huy" "Centralize access, governance, module registry, and discovery for PPJ AI tools and automation modules." "Strong" @("AI Hub", "Web Tong Hop Tool", "Web Tổng Hợp Tool") @("Do not absorb or merge individual project notes into AI Hub.")
    New-Project "PPJ.PERRI.Chatbot.v3.2" "PPJ.PERRI.Chatbot.md" "Internal Chatbot & AI Platforms" "AI access, agent orchestration, helpdesk, shared platforms" "Department Agents, Permission, Logs" "Production / Support" "TBD" "Permission Enhancement" "PPJ departments / Khoa / Nam" "Provide controlled chatbot orchestration for PPJ knowledge, Q&A, data lookup, and tool workflows." "Strong" @("PPJ.PERRI.Chatbot", "PERRI Chatbot", "PPJ PERRI") @("Do not treat as simple FAQ bot only.")
    New-Project "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0" "PPJ.GLPI-Helpdesk-AI Chatbot.md" "Internal Chatbot & AI Platforms" "AI access, agent orchestration, helpdesk, shared platforms" "IT Helpdesk, GLPI, ERP Support" "Maintenance" "TBD" "Maintenance and Support" "IT / ERP Helpdesk / Huy" "Help users resolve IT/ERP support questions and route GLPI requests faster." "Strong" @("PPJ.GLPI.Helpdesk.v1.0", "PPJ.GLPI-Helpdesk-AI Chatbot", "GLPI Helpdesk AI") @("Do not claim ticket creation is implemented unless confirmed.")

    New-Project "HR.SSPFD.Workflow.v1.1" "HR.SS&PFD.v1.1.md" "HR" "Employee, payroll, BHXH and HR-sensitive workflows" "WISER, BHXH, Sensitive HR Data" "Analysis" "TBD" "Data Confirmation" "HR / Khoa" "Prepare structured HR/BHXH workflow support using latest confirmed HR-sensitive data." "Strong" @("HR.SS&PFD.v1.1", "HR Project") @("Do not expand SS&PFD without evidence; HR data is sensitive.")

    New-Project "FD.Datamart.v2.2" "FD.Datamart.v2.2.md" "Fabric / Textiles Technique" "Fabric, pattern, BOM, technical knowledge, 3D and scanning" "Directus, QR, Hanger, Fabric Data" "Final Stabilization / Pending Acceptance" "TBD" "Final Stabilization / Closeout" "FD / Khoa / Nghia / Nam" "Manage FD/fabric/hanger data in Directus with QR support for hanger operation." "Strong" @("FD.HangerQR-Library.v2.2", "FD Hanger", "QR Hanger") @("Do not describe FD Datamart as CPD Datamart.", "Do not mention image search or 3D sample library as FD scope unless confirmed.")
    New-Project "TD.TechnicalKnowledge.Platform.v2.1" "TD.TechnicalPlatform_v2.1.md" "Fabric / Textiles Technique" "Fabric, pattern, BOM, technical knowledge, 3D and scanning" "Merchandising, Costing, Training" "Analysis" "TBD" "New Request / Analysis" "Technical Department / Khoa / Huy" "Create technical knowledge foundation for pattern, BOM, construction, technical documents, and costing agents." "Strong" @("TD.TechnicalPlatform_v2.1", "Tech.Knowledge.Platform.v2.1", "Anh Tu platform") @("Respect technical data sensitivity.")
    New-Project "CPD.Datamart.v1.1" "CPD.Datamart.v1.1.md" "Fabric / Textiles Technique" "Fabric, pattern, BOM, technical knowledge, 3D and scanning" "3D Design, Image Search, Visual Assets" "Development" "TBD" "Data Foundation" "CPD / 3D Design / Linh / Phat" "Build searchable visual sample library and image search for 3D Design." "Strong" @("CPD.3D&Pattern.MGMT.v1.1", "CPD DataMart", "CPD / 3D Design Datamart") @("Do not merge with FD.Datamart.v2.2.", "Keep image search and 3D sample library as core scope.")
    New-Project "PPJxNUNOX.ScanTrial" "PPJxNUNOX.md" "Fabric / Textiles Technique" "Fabric, pattern, BOM, technical knowledge, 3D and scanning" "Hardware Trial, Sourcing, Factory" "Hardware Trial / Feasibility Assessment" "TBD" "Hardware Trial / Feasibility Assessment" "Sourcing / Fabric / Khoa / Huy" "Evaluate NUNOX high-quality fabric image capture hardware for fabric/sample data foundation." "Strong" @("PPJxNUNOX", "PPJ x NUNOX", "PPJ x Nunox", "NUNOX") @("Not canceled unless formal stop decision exists.")
    New-Project "PPJxStratova.AI" "PPJxStratova AI.md" "Fabric / Textiles Technique" "Fabric, pattern, BOM, technical knowledge, 3D and scanning" "Pattern AI, Vendor Screening, Lessons Learned" "Canceled / Closed" "TBD" "Canceled / Closed" "Khoa / Pattern AI evaluation" "Preserve Pattern AI vendor screening history and lessons learned." "Strong" @("PPJxStratova AI", "PPJ x Stratova AI", "Stratova AI") @("Use canceled/closed lifecycle; do not treat as active delivery.")
)

$CanonicalCorrections = @(
    [pscustomobject]@{ Old = "MER.MARKET.INTELLIGENCE.v5.5"; New = "MER.MARKET.INTELLIGENCE.v1.1"; Reason = "Official version reset to v1.1" }
    [pscustomobject]@{ Old = "FD.HangerQR-Library.v2.2"; New = "FD.Datamart.v2.2"; Reason = "Official FD/fabric Directus QR hanger datamart name" }
    [pscustomobject]@{ Old = "PPJ.GLPI.Helpdesk.v1.0"; New = "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0"; Reason = "Official GLPI AI chatbot code" }
    [pscustomobject]@{ Old = "CPD.3D&Pattern.MGMT.v1.1"; New = "CPD.Datamart.v1.1"; Reason = "Official CPD/3D visual datamart code" }
    [pscustomobject]@{ Old = "WASH.SAMPLING.MGMT.PORTAL.v1.1"; New = "WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1"; Reason = "Official expanded Wash Sampling Management code" }
)

function Get-RelativePath {
    param([string]$FullPath)
    $resolved = [System.IO.Path]::GetFullPath($FullPath)
    $root = [System.IO.Path]::GetFullPath($VaultRoot)
    if ($resolved.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $resolved.Substring($root.Length).TrimStart("\")
    }
    return $FullPath
}

function Get-Utf8Content {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return "" }
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Set-Utf8Content {
    param([string]$Path, [string]$Content)
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Backup-File {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    if (-not (Test-Path -LiteralPath $BackupRoot)) { New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null }
    $relative = Get-RelativePath $Path
    $safeName = ($relative -replace "[:/\\]", "_") + ".bak"
    Copy-Item -LiteralPath $Path -Destination (Join-Path $BackupRoot $safeName) -Force
}

function Write-FileIfChanged {
    param([string]$Path, [string]$Content, [string]$Label)
    $old = Get-Utf8Content $Path
    if ($old -eq $Content) { return [pscustomobject]@{ File = Get-RelativePath $Path; Action = "UNCHANGED"; Label = $Label } }
    if ($Apply) {
        Backup-File $Path
        Set-Utf8Content -Path $Path -Content $Content
        return [pscustomobject]@{ File = Get-RelativePath $Path; Action = "UPDATED"; Label = $Label }
    }
    return [pscustomobject]@{ File = Get-RelativePath $Path; Action = "WOULD UPDATE"; Label = $Label }
}

function Update-ManagedBlock {
    param([string]$Path, [string]$StartMarker, [string]$EndMarker, [string]$BlockContent, [string]$DefaultHeader)
    $content = Get-Utf8Content $Path
    if ([string]::IsNullOrWhiteSpace($content)) { $content = $DefaultHeader.TrimEnd() + "`r`n" }
    $block = "`r`n$StartMarker`r`n$BlockContent`r`n$EndMarker`r`n"
    $pattern = [regex]::Escape($StartMarker) + "(?s).*?" + [regex]::Escape($EndMarker)
    if ($content -match [regex]::Escape($StartMarker)) {
        $newContent = [regex]::Replace($content, $pattern, ($StartMarker + "`r`n" + $BlockContent + "`r`n" + $EndMarker))
    } else {
        $newContent = $content.TrimEnd() + "`r`n" + $block
    }
    return Write-FileIfChanged -Path $Path -Content $newContent -Label "managed block"
}

function ConvertTo-YamlQuoted {
    param([string]$Value)
    if ($null -eq $Value) { $Value = "" }
    return '"' + ($Value -replace '"', '\"') + '"'
}

function Set-YamlScalar {
    param([string]$Yaml, [string]$Key, [string]$Value)
    $escapedKey = [regex]::Escape($Key)
    $line = "${Key}: $Value"
    if ($Yaml -match "(?m)^$escapedKey\s*:") {
        return [regex]::Replace($Yaml, "(?m)^$escapedKey\s*:.*$", $line)
    }
    if ([string]::IsNullOrWhiteSpace($Yaml)) { return $line }
    return $Yaml.TrimEnd() + "`r`n" + $line
}

function Get-NoteBase {
    param([string]$CurrentFile)
    if ([string]::IsNullOrWhiteSpace($CurrentFile) -or $CurrentFile -eq "TBD") { return "" }
    return [System.IO.Path]::GetFileNameWithoutExtension($CurrentFile)
}

function Escape-JsonText {
    param([string]$Text)
    if ($null -eq $Text) { return "" }
    return $Text
}

function Get-DomainCapability {
    param([string]$DomainName)
    foreach ($d in $Domains) { if ($d.Name -eq $DomainName) { return $d.Capability } }
    return "TBD"
}

function Build-DomainModelMarkdown {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# PPJ Portfolio Domain Model")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Last updated: $Today")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Core Rule")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Primary Domain = Business Owner + Primary Users + Primary Business Capability.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Domain is not technology, vendor, system, or technical team. Lifecycle and progress are separate from domain. Each project appears in exactly one Primary Domain. Secondary domains are tags only.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Official Domains")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Primary Domain | Capability |")
    [void]$sb.AppendLine("| --- | --- |")
    foreach ($d in $Domains) { [void]$sb.AppendLine("| $($d.Name) | $($d.Capability) |") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Boundary Rules")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("- Sourcing / Purchasing has two capabilities: Sourcing = supplier, material, sample, search, intelligence; Purchasing = transaction, allocation, indent, GDI, inventory workflow.")
    [void]$sb.AppendLine("- Do not mix sourcing intelligence with purchasing transaction automation.")
    [void]$sb.AppendLine("- MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1 belongs to Merchandising, not Finance, because primary scope is costing check, commercial cost, invoice information, and Chico's-specific logic.")
    [void]$sb.AppendLine("- WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1 = sampling request, trial, result, approval, history.")
    [void]$sb.AppendLine("- PROD.COWASH.v2.0 = operational Wash data, machine, output, delay, rework.")
    [void]$sb.AppendLine("- PPJ.InvoiceDownloader.v1.2 belongs to Finance / Accounting because primary business use is invoice data, reporting, and downstream accounting usage.")
    [void]$sb.AppendLine("- PPJ.AI.Hub.v2.1 = application discovery and access.")
    [void]$sb.AppendLine("- PPJ.PERRI.Chatbot.v3.2 = conversational orchestration and controlled tool execution.")
    [void]$sb.AppendLine("- PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0 = IT-specific support and troubleshooting chatbot.")
    [void]$sb.AppendLine("- HR remains separate because it has sensitive personal data, distinct business rules, data owner, permission, and governance.")
    [void]$sb.AppendLine("- FD.Datamart.v2.2 = Fabric + Hanger + QR.")
    [void]$sb.AppendLine("- CPD.Datamart.v1.1 = 3D + Visual Assets + Image Search.")
    [void]$sb.AppendLine("- TD.TechnicalKnowledge.Platform.v2.1 = Pattern + BOM + Construction + Technical Documents.")
    [void]$sb.AppendLine("- PPJxNUNOX.ScanTrial = Fabric Image Capture Hardware.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Lifecycle and Progress Rule")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Never use percentages as lifecycle. Use `Lifecycle: Development` and `Progress: 50%`, or `Lifecycle: UAT / Stabilization` and `Progress: 80%`.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Allowed lifecycle values:")
    foreach ($l in $AllowedLifecycle) { [void]$sb.AppendLine("- $l") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Canonical Placement")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Canonical Code | Primary Domain | Lifecycle | Current File |")
    [void]$sb.AppendLine("| --- | --- | --- | --- |")
    foreach ($p in $Projects) { [void]$sb.AppendLine("| $($p.CanonicalCode) | $($p.PrimaryDomain) | $($p.Lifecycle) | $($p.CurrentFile) |") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Canonical Corrections")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Old / Board Code | New Canonical Code | Reason |")
    [void]$sb.AppendLine("| --- | --- | --- |")
    foreach ($c in $CanonicalCorrections) { [void]$sb.AppendLine("| $($c.Old) | $($c.New) | $($c.Reason) |") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Canvas Usage Rule")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Use `03_Projects/Canvas/PPJ_Domain_Encapsulation.canvas` for domain encapsulation. Do not duplicate project cards across domains. Secondary domains are tags, not duplicate cards. Existing operational canvases remain unchanged by this first pass.")
    return $sb.ToString()
}

function Build-DomainMatrixMarkdown {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# PPJ Project Domain Assignment Matrix")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Last updated: $Today")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Canonical Code | Current File | Primary Domain | Primary Capability | Secondary Domains | Lifecycle | Progress | Status / Gate | Owner / Primary Users | Confidence | Notes |")
    [void]$sb.AppendLine("| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |")
    foreach ($p in $Projects) {
        $notes = "Primary domain is based on owner/users/capability."
        [void]$sb.AppendLine("| $($p.CanonicalCode) | $($p.CurrentFile) | $($p.PrimaryDomain) | $($p.PrimaryCapability) | $($p.SecondaryDomains) | $($p.Lifecycle) | $($p.Progress) | $($p.Gate) | $($p.OwnerUsers) | $($p.Confidence) | $notes |")
    }
    return $sb.ToString()
}

function Build-DomainOverlayBlock {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("## Official Domain Governance Overlay")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Last updated: $Today")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Canonical Code | Current File | Primary Domain | Secondary Domains | Lifecycle | Progress | Current Gate |")
    [void]$sb.AppendLine("| --- | --- | --- | --- | --- | --- | --- |")
    foreach ($p in $Projects) {
        [void]$sb.AppendLine("| $($p.CanonicalCode) | $($p.CurrentFile) | $($p.PrimaryDomain) | $($p.SecondaryDomains) | $($p.Lifecycle) | $($p.Progress) | $($p.Gate) |")
    }
    return $sb.ToString()
}

function Build-NamingDictionaryBlock {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("## Official Domain Model Canonical Corrections")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Last updated: $Today")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Canonical Code | Current Storage Note | Primary Domain | Alias / Old Names | Rename Pending |")
    [void]$sb.AppendLine("| --- | --- | --- | --- | --- |")
    foreach ($p in $Projects) {
        $aliasText = ($p.Aliases -join "; ")
        $renamePending = if ((Get-NoteBase $p.CurrentFile) -ne $p.CanonicalCode) { "Yes - pending explicit rename approval" } else { "No" }
        [void]$sb.AppendLine("| ``$($p.CanonicalCode)`` | [[$(Get-NoteBase $p.CurrentFile)]] | $($p.PrimaryDomain) | $aliasText | $renamePending |")
    }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("### Board Code Corrections")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Old / Board Code | New Canonical Code | Reason |")
    [void]$sb.AppendLine("| --- | --- | --- |")
    foreach ($c in $CanonicalCorrections) { [void]$sb.AppendLine("| ``$($c.Old)`` | ``$($c.New)`` | $($c.Reason) |") }
    return $sb.ToString()
}

function Build-AliasMapBlock {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("## Official Domain Model Alias Overlay")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Last updated: $Today")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Alias / Current Name | Canonical Code | Current Storage Note | Reason | Confidence |")
    [void]$sb.AppendLine("| --- | --- | --- | --- | --- |")
    foreach ($p in $Projects) {
        [void]$sb.AppendLine("| $($p.CurrentFile) | $($p.CanonicalCode) | $($p.CurrentFile) | Current storage note; do not rename without approval | $($p.Confidence) |")
        foreach ($a in $p.Aliases) { [void]$sb.AppendLine("| $a | $($p.CanonicalCode) | $($p.CurrentFile) | Alias preserved under official domain model | $($p.Confidence) |") }
    }
    foreach ($c in $CanonicalCorrections) { [void]$sb.AppendLine("| $($c.Old) | $($c.New) | See current file mapping | Official canonical correction | Strong |") }
    return $sb.ToString()
}

function Build-RegistryOverlayBlock {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("## Official Primary Domain Overlay")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Last updated: $Today")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Project Name | Canonical Code | Current File | Primary Domain | Primary Capability | Lifecycle | Progress | Status / Gate |")
    [void]$sb.AppendLine("| --- | --- | --- | --- | --- | --- | --- | --- |")
    foreach ($p in $Projects) { [void]$sb.AppendLine("| $($p.CanonicalCode) | $($p.CanonicalCode) | $($p.CurrentFile) | $($p.PrimaryDomain) | $($p.PrimaryCapability) | $($p.Lifecycle) | $($p.Progress) | $($p.Gate) |") }
    return $sb.ToString()
}

function Build-ResourceOverlayBlock {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("## Official Domain and Capability Overlay")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Last updated: $Today")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Canonical Project Name | Current File | Primary Domain | Primary Capability | Secondary Domains | Lifecycle / Progress | Owner / Primary Users | Current Gate |")
    [void]$sb.AppendLine("| --- | --- | --- | --- | --- | --- | --- | --- |")
    foreach ($p in $Projects) { [void]$sb.AppendLine("| $($p.CanonicalCode) | $($p.CurrentFile) | $($p.PrimaryDomain) | $($p.PrimaryCapability) | $($p.SecondaryDomains) | $($p.Lifecycle) / $($p.Progress) | $($p.OwnerUsers) | $($p.Gate) |") }
    return $sb.ToString()
}

function Update-AgentDomainRule {
    $block = @"
## Portfolio Domain Governance Rule

- Primary Domain = Business Owner + Primary Users + Primary Business Capability.
- Domain is not technology, system, vendor, or technical team.
- Lifecycle and progress are separate from domain.
- Each project has exactly one Primary Domain.
- Secondary domains are tags only and must not duplicate Canvas cards.
- Domain model source file: `03_Projects/_Registry/PPJ_PORTFOLIO_DOMAIN_MODEL.md`.
- Before answering domain questions, read the domain model and assignment matrix.
"@
    return Update-ManagedBlock -Path $AgentPath -StartMarker "<!-- PPJ_DOMAIN_RULE_START -->" -EndMarker "<!-- PPJ_DOMAIN_RULE_END -->" -BlockContent $block.Trim() -DefaultHeader "# PPJ Knowledge Base Agent"
}

function Update-MemoryCard {
    param([object]$Project)
    $memoryPath = Join-Path $MemoryDir ($Project.CanonicalCode + ".memory.md")
    $content = Get-Utf8Content $memoryPath
    if ([string]::IsNullOrWhiteSpace($content)) {
        $content = "---`r`ntype: project_memory`r`nproject_name: `"$($Project.CanonicalCode)`"`r`n---`r`n`r`n# Project Memory: $($Project.CanonicalCode)`r`n"
    }
    $match = [regex]::Match($content, "(?s)\A---\r?\n(.*?)\r?\n---\r?\n?")
    if ($match.Success) {
        $yaml = $match.Groups[1].Value
        $body = $content.Substring($match.Length)
    } else {
        $yaml = "type: " + (ConvertTo-YamlQuoted "project_memory")
        $body = $content
    }
    $yaml = Set-YamlScalar $yaml "canonical_code" (ConvertTo-YamlQuoted $Project.CanonicalCode)
    $yaml = Set-YamlScalar $yaml "current_file" (ConvertTo-YamlQuoted $Project.CurrentFile)
    $yaml = Set-YamlScalar $yaml "primary_domain" (ConvertTo-YamlQuoted $Project.PrimaryDomain)
    $yaml = Set-YamlScalar $yaml "primary_capability" (ConvertTo-YamlQuoted $Project.PrimaryCapability)
    $yaml = Set-YamlScalar $yaml "secondary_domains" (ConvertTo-YamlQuoted $Project.SecondaryDomains)
    $yaml = Set-YamlScalar $yaml "lifecycle" (ConvertTo-YamlQuoted $Project.Lifecycle)
    $yaml = Set-YamlScalar $yaml "progress" (ConvertTo-YamlQuoted $Project.Progress)
    $yaml = Set-YamlScalar $yaml "current_gate" (ConvertTo-YamlQuoted $Project.Gate)
    $yaml = Set-YamlScalar $yaml "last_verified" (ConvertTo-YamlQuoted $Today)
    $yaml = Set-YamlScalar $yaml "confidence" (ConvertTo-YamlQuoted $Project.Confidence)

    $boundary = New-Object System.Text.StringBuilder
    [void]$boundary.AppendLine("## Domain Governance")
    [void]$boundary.AppendLine("")
    [void]$boundary.AppendLine("- Canonical Code: $($Project.CanonicalCode)")
    [void]$boundary.AppendLine("- Current File: [[$(Get-NoteBase $Project.CurrentFile)]]")
    [void]$boundary.AppendLine("- Primary Domain: $($Project.PrimaryDomain)")
    [void]$boundary.AppendLine("- Secondary Domains: $($Project.SecondaryDomains)")
    [void]$boundary.AppendLine("- Lifecycle: $($Project.Lifecycle)")
    [void]$boundary.AppendLine("- Progress: $($Project.Progress)")
    [void]$boundary.AppendLine("- Current Gate: $($Project.Gate)")
    [void]$boundary.AppendLine("")
    [void]$boundary.AppendLine("## Domain Do Not Drift Rules")
    foreach ($r in $Project.DoNotDrift) { [void]$boundary.AppendLine("- $r") }

    $start = "<!-- PPJ_DOMAIN_GOVERNANCE_START -->"
    $end = "<!-- PPJ_DOMAIN_GOVERNANCE_END -->"
    $block = "$start`r`n$($boundary.ToString().Trim())`r`n$end"
    if ($body -match [regex]::Escape($start)) {
        $body = [regex]::Replace($body, [regex]::Escape($start) + "(?s).*?" + [regex]::Escape($end), $block)
    } else {
        $body = $body.TrimEnd() + "`r`n`r`n" + $block + "`r`n"
    }
    $newContent = "---`r`n$yaml`r`n---`r`n$body"
    return Write-FileIfChanged -Path $memoryPath -Content $newContent -Label "memory card domain metadata"
}

function Update-ProjectNoteManagedBlock {
    param([object]$Project)
    $projectPath = Join-Path $VaultRoot ("03_Projects\" + $Project.CurrentFile)
    if (-not (Test-Path -LiteralPath $projectPath)) {
        if ($CreateMissingOfficialNotes) {
            $base = Get-NoteBase $Project.CurrentFile
            $new = "---`r`ntype: project`r`ncanonical_code: `"$($Project.CanonicalCode)`"`r`nprimary_domain: `"$($Project.PrimaryDomain)`"`r`n---`r`n`r`n# $($Project.CanonicalCode)`r`n"
            return Write-FileIfChanged -Path $projectPath -Content $new -Label "created missing official project note"
        }
        return [pscustomobject]@{ File = "03_Projects/$($Project.CurrentFile)"; Action = "SKIPPED"; Label = "missing project note; creation not approved" }
    }
    $block = @"
## Domain Governance

- Canonical Code: $($Project.CanonicalCode)
- Current File: [[$(Get-NoteBase $Project.CurrentFile)]]
- Primary Domain: $($Project.PrimaryDomain)
- Primary Capability: $($Project.PrimaryCapability)
- Secondary Domains: $($Project.SecondaryDomains)
- Lifecycle: $($Project.Lifecycle)
- Progress: $($Project.Progress)
- Current Gate: $($Project.Gate)
- Owner / Primary Users: $($Project.OwnerUsers)

## Domain Boundary

Primary Domain is based on business owner, primary users, and primary business capability. Lifecycle and progress are separate fields.

## Do Not Drift Rules
$((($Project.DoNotDrift | ForEach-Object { "- $_" }) -join "`r`n"))
"@
    return Update-ManagedBlock -Path $projectPath -StartMarker "<!-- PPJ_DOMAIN_GOVERNANCE_START -->" -EndMarker "<!-- PPJ_DOMAIN_GOVERNANCE_END -->" -BlockContent $block.Trim() -DefaultHeader "# $($Project.CanonicalCode)"
}

function Build-DomainCanvasJson {
    $nodes = @()
    $edges = @()
    $nodes += [pscustomobject]@{ id = "title"; type = "text"; x = 0; y = -520; width = 3400; height = 180; text = "PPJ AI & Automation Portfolio - Domain Encapsulation View`r`nPrimary Domain = Business Owner + Primary Users + Primary Business Capability"; color = "1" }
    $nodes += [pscustomobject]@{ id = "legend"; type = "text"; x = 3500; y = -520; width = 1600; height = 180; text = "Legend`r`nLifecycle and Progress are separate.`r`nOne project appears in one primary domain only.`r`nSecondary domains are tags, not duplicate cards.`r`nNo existing portfolio canvases are updated by this view."; color = "6" }

    $groupW = 2500
    $groupH = 1700
    $gapX = 180
    $gapY = 180
    $cardW = 760
    $cardH = 270
    $cardGapX = 40
    $cardGapY = 35
    for ($i = 0; $i -lt $Domains.Count; $i++) {
        $d = $Domains[$i]
        $gx = ($i % 3) * ($groupW + $gapX)
        $gy = [math]::Floor($i / 3) * ($groupH + $gapY)
        $domainId = "domain-" + ($i + 1)
        $nodes += [pscustomobject]@{ id = $domainId; type = "group"; x = $gx; y = $gy; width = $groupW; height = $groupH; label = $d.Name; color = "4" }
        $nodes += [pscustomobject]@{ id = $domainId + "-capability"; type = "text"; x = $gx + 35; y = $gy + 45; width = $groupW - 70; height = 90; text = "Capability: $($d.Capability)"; color = "5" }
        $domainProjects = @($Projects | Where-Object { $_.PrimaryDomain -eq $d.Name })
        for ($j = 0; $j -lt $domainProjects.Count; $j++) {
            $p = $domainProjects[$j]
            $col = $j % 3
            $row = [math]::Floor($j / 3)
            $cx = $gx + 35 + ($col * ($cardW + $cardGapX))
            $cy = $gy + 170 + ($row * ($cardH + $cardGapY))
            $base = Get-NoteBase $p.CurrentFile
            $linkLine = if ((Test-Path -LiteralPath (Join-Path $VaultRoot ("03_Projects\" + $p.CurrentFile)))) { "[[$base]]" } else { "Project note: Missing / Needs Creation" }
            $text = "$linkLine`r`n`r`n$($p.CanonicalCode)`r`n`r`nDomain: $($p.PrimaryDomain)`r`nLifecycle: $($p.Lifecycle)`r`nProgress: $($p.Progress)`r`nGate: $($p.Gate)`r`n`r`nOutcome`r`n- $($p.Outcome)`r`n`r`nSecondary`r`n- $($p.SecondaryDomains)"
            $nodes += [pscustomobject]@{ id = "card-" + ($p.CanonicalCode -replace "[^A-Za-z0-9]", "-"); type = "text"; x = $cx; y = $cy; width = $cardW; height = $cardH; text = $text; color = "2" }
        }
    }
    $canvas = [pscustomobject]@{ nodes = $nodes; edges = $edges }
    return ($canvas | ConvertTo-Json -Depth 100)
}

function Test-PlanHardStops {
    $hardStops = New-Object System.Collections.Generic.List[string]
    $warnings = New-Object System.Collections.Generic.List[string]

    if ($RenameCanonicalFiles -and -not $Force) { $hardStops.Add("RenameCanonicalFiles was provided without -Force explicit approval.") }

    $byCanon = $Projects | Group-Object CanonicalCode | Where-Object { $_.Count -gt 1 }
    foreach ($g in $byCanon) { $hardStops.Add("Canonical code conflict with two current files: $($g.Name)") }

    $byFile = $Projects | Where-Object { $_.CurrentFile -and $_.CurrentFile -ne "TBD" } | Group-Object CurrentFile | Where-Object { $_.Count -gt 1 }
    foreach ($g in $byFile) { $hardStops.Add("Current file conflict with two canonical codes: $($g.Name)") }

    foreach ($p in $Projects) {
        if ($p.Lifecycle -match '^\s*\d+%\s*$') { $hardStops.Add("Lifecycle contains only percentage for $($p.CanonicalCode).") }
        if ($AllowedLifecycle -notcontains $p.Lifecycle) { $warnings.Add("Lifecycle '$($p.Lifecycle)' for $($p.CanonicalCode) is outside strict list but retained as gate-context-compatible lifecycle.") }
    }

    $fd = $Projects | Where-Object { $_.CanonicalCode -eq "FD.Datamart.v2.2" } | Select-Object -First 1
    $cpd = $Projects | Where-Object { $_.CanonicalCode -eq "CPD.Datamart.v1.1" } | Select-Object -First 1
    if ($fd.PrimaryDomain -ne "Fabric / Textiles Technique" -or $cpd.PrimaryDomain -ne "Fabric / Textiles Technique" -or $fd.CanonicalCode -eq $cpd.CanonicalCode) { $hardStops.Add("FD.Datamart and CPD.Datamart boundary failure.") }

    $chicos = $Projects | Where-Object { $_.CanonicalCode -eq "MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1" } | Select-Object -First 1
    if ($chicos.PrimaryDomain -eq "Finance / Accounting") { $hardStops.Add("MER.CHICOS placed under Finance.") }

    $grn = $Projects | Where-Object { $_.CanonicalCode -like "ACC.GRN-SupplierInvoiceBot*" }
    if (@($grn).Count -ne 1 -or $grn[0].CanonicalCode -ne "ACC.GRN-SupplierInvoiceBot.v2.3") { $hardStops.Add("Unresolved ACC.GRN v1.1/v2.3 conflict.") }

    foreach ($p in $Projects) {
        $projectPath = Join-Path $VaultRoot ("03_Projects\" + $p.CurrentFile)
        if (-not (Test-Path -LiteralPath $projectPath)) {
            if (-not $CreateMissingOfficialNotes) { $warnings.Add("Missing official project note, not creating without -CreateMissingOfficialNotes: $($p.CurrentFile)") }
        }
    }

    return [pscustomobject]@{ HardStops = @($hardStops); Warnings = @($warnings) }
}

function Write-DryRunPreview {
    param([object]$PlanCheck)
    Write-Host ""
    Write-Host "PPJ Portfolio Domain Model Update - DRYRUN"
    Write-Host "Vault: $VaultRoot"
    Write-Host "Official projects: $($Projects.Count)"
    Write-Host "Official domains: $($Domains.Count)"
    Write-Host ""
    Write-Host "Projects by domain:"
    foreach ($d in $Domains) {
        $count = @($Projects | Where-Object { $_.PrimaryDomain -eq $d.Name }).Count
        Write-Host ("- {0}: {1}" -f $d.Name, $count)
    }
    Write-Host ""
    Write-Host "Canonical code mapping:"
    foreach ($p in $Projects) { Write-Host ("- {0} -> {1}" -f $p.CurrentFile, $p.CanonicalCode) }
    Write-Host ""
    Write-Host "Canonical corrections:"
    foreach ($c in $CanonicalCorrections) { Write-Host ("- {0} -> {1}" -f $c.Old, $c.New) }
    Write-Host ""
    Write-Host "Missing official notes:"
    $missing = @($Projects | Where-Object { -not (Test-Path -LiteralPath (Join-Path $VaultRoot ("03_Projects\" + $_.CurrentFile))) })
    if ($missing.Count -eq 0) { Write-Host "- None" } else { foreach ($m in $missing) { Write-Host ("- {0}" -f $m.CurrentFile) } }
    Write-Host ""
    Write-Host "Files that would be updated:"
    if ($UpdateDomainModel) { Write-Host "- AGENTS.md (domain rule if needed)"; Write-Host "- 03_Projects/_Registry/PPJ_PORTFOLIO_DOMAIN_MODEL.md"; Write-Host "- 03_Projects/_Registry/PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md" }
    if ($UpdateRegistry) { Write-Host "- 03_Projects/_Registry/PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY.md"; Write-Host "- 03_Projects/_Registry/PPJ_PROJECT_MEMORY_INDEX.md"; Write-Host "- 03_Projects/_Registry/PPJ_PROJECT_REGISTRY.md" }
    if ($UpdateAliasMap) { Write-Host "- 03_Projects/_Registry/PPJ_PROJECT_ALIAS_MAP.md" }
    if ($UpdateResourceMatrix) { Write-Host "- 03_Projects/_Registry/PPJ_PROJECT_RESOURCE_MATRIX.md" }
    if ($UpdateMemory) { Write-Host "- 03_Projects/_Registry/Project_Memory/*.memory.md" }
    if ($UpdateProjectNotes) { Write-Host "- 03_Projects/*.md managed domain blocks" } else { Write-Host "- Project notes skipped because -UpdateProjectNotes not provided" }
    if ($CreateDomainCanvas) { Write-Host "- 03_Projects/Canvas/PPJ_Domain_Encapsulation.canvas" }
    Write-Host ""
    Write-Host "Files that would be created:"
    if ($UpdateDomainModel -and -not (Test-Path -LiteralPath $DomainModelPath)) { Write-Host "- 03_Projects/_Registry/PPJ_PORTFOLIO_DOMAIN_MODEL.md" }
    if ($UpdateDomainModel -and -not (Test-Path -LiteralPath $DomainMatrixPath)) { Write-Host "- 03_Projects/_Registry/PPJ_PROJECT_DOMAIN_ASSIGNMENT_MATRIX.md" }
    if ($CreateDomainCanvas -and -not (Test-Path -LiteralPath $DomainCanvasPath)) { Write-Host "- 03_Projects/Canvas/PPJ_Domain_Encapsulation.canvas" }
    Write-Host "- Operation log and final report only on Apply"
    Write-Host ""
    Write-Host "Hard stops: $($PlanCheck.HardStops.Count)"
    foreach ($h in $PlanCheck.HardStops) { Write-Host "- $h" }
    Write-Host "Warnings: $($PlanCheck.Warnings.Count)"
    foreach ($w in $PlanCheck.Warnings) { Write-Host "- $w" }
    Write-Host ""
    Write-Host "DryRun complete. No files modified."
}

function Invoke-Apply {
    $results = @()
    if (-not (Test-Path -LiteralPath $RegistryDir)) { New-Item -ItemType Directory -Path $RegistryDir -Force | Out-Null }
    if (-not (Test-Path -LiteralPath $MemoryDir)) { New-Item -ItemType Directory -Path $MemoryDir -Force | Out-Null }
    if (-not (Test-Path -LiteralPath $CanvasDir)) { New-Item -ItemType Directory -Path $CanvasDir -Force | Out-Null }
    if (-not (Test-Path -LiteralPath $ReportDir)) { New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null }
    if (-not (Test-Path -LiteralPath $AuditDir)) { New-Item -ItemType Directory -Path $AuditDir -Force | Out-Null }

    if ($UpdateDomainModel) {
        $results += Update-AgentDomainRule
        $results += Write-FileIfChanged -Path $DomainModelPath -Content (Build-DomainModelMarkdown) -Label "domain model"
        $results += Write-FileIfChanged -Path $DomainMatrixPath -Content (Build-DomainMatrixMarkdown) -Label "domain assignment matrix"
    }
    if ($UpdateRegistry) {
        $results += Update-ManagedBlock -Path $NamingDictionaryPath -StartMarker "<!-- PPJ_DOMAIN_CANONICAL_OVERLAY_START -->" -EndMarker "<!-- PPJ_DOMAIN_CANONICAL_OVERLAY_END -->" -BlockContent (Build-NamingDictionaryBlock) -DefaultHeader "# PPJ Project Canonical Naming Dictionary"
        $results += Update-ManagedBlock -Path $MemoryIndexPath -StartMarker "<!-- PPJ_DOMAIN_MEMORY_INDEX_OVERLAY_START -->" -EndMarker "<!-- PPJ_DOMAIN_MEMORY_INDEX_OVERLAY_END -->" -BlockContent (Build-DomainOverlayBlock) -DefaultHeader "# PPJ Project Memory Index"
        $results += Update-ManagedBlock -Path $RegistryPath -StartMarker "<!-- PPJ_DOMAIN_REGISTRY_OVERLAY_START -->" -EndMarker "<!-- PPJ_DOMAIN_REGISTRY_OVERLAY_END -->" -BlockContent (Build-RegistryOverlayBlock) -DefaultHeader "# PPJ Project Registry"
    }
    if ($UpdateAliasMap) {
        $results += Update-ManagedBlock -Path $AliasMapPath -StartMarker "<!-- PPJ_DOMAIN_ALIAS_OVERLAY_START -->" -EndMarker "<!-- PPJ_DOMAIN_ALIAS_OVERLAY_END -->" -BlockContent (Build-AliasMapBlock) -DefaultHeader "# PPJ Project Alias Map"
    }
    if ($UpdateResourceMatrix) {
        $results += Update-ManagedBlock -Path $ResourceMatrixPath -StartMarker "<!-- PPJ_DOMAIN_RESOURCE_OVERLAY_START -->" -EndMarker "<!-- PPJ_DOMAIN_RESOURCE_OVERLAY_END -->" -BlockContent (Build-ResourceOverlayBlock) -DefaultHeader "# PPJ Project Resource Matrix"
    }
    if ($UpdateMemory) {
        foreach ($p in $Projects) { $results += Update-MemoryCard -Project $p }
    }
    if ($UpdateProjectNotes) {
        foreach ($p in $Projects) { $results += Update-ProjectNoteManagedBlock -Project $p }
    }
    if ($CreateDomainCanvas) {
        if (Test-Path -LiteralPath $DomainCanvasPath) {
            if (-not (Test-Path -LiteralPath $CanvasBackupRoot)) { New-Item -ItemType Directory -Path $CanvasBackupRoot -Force | Out-Null }
            Copy-Item -LiteralPath $DomainCanvasPath -Destination (Join-Path $CanvasBackupRoot "PPJ_Domain_Encapsulation.canvas") -Force
        }
        $json = Build-DomainCanvasJson
        $json | ConvertFrom-Json | Out-Null
        $results += Write-FileIfChanged -Path $DomainCanvasPath -Content $json -Label "domain encapsulation canvas"
    }

    $validation = Invoke-Validation
    $log = Build-OperationLog -Results $results -Validation $validation
    Set-Utf8Content -Path $OperationLogPath -Content $log
    $report = Build-FinalReport -Results $results -Validation $validation
    Set-Utf8Content -Path $FinalReportPath -Content $report

    Write-Host ""
    Write-Host "Apply completed."
    Write-Host "Backup folder: $BackupRoot"
    Write-Host "Operation log: $(Get-RelativePath $OperationLogPath)"
    Write-Host "Final report: $(Get-RelativePath $FinalReportPath)"
    Write-Host ""
    Write-Host "Updated results:"
    foreach ($r in $results) { Write-Host ("[{0}] {1} - {2}" -f $r.Action, $r.File, $r.Label) }
    Write-Host ""
    Write-Host "Validation hard stops: $($validation.HardStops.Count)"
    foreach ($h in $validation.HardStops) { Write-Host "- $h" }
    Write-Host "Validation warnings: $($validation.Warnings.Count)"
    foreach ($w in $validation.Warnings) { Write-Host "- $w" }
}

function Invoke-Validation {
    $check = Test-PlanHardStops
    $hardStops = New-Object System.Collections.Generic.List[string]
    $warnings = New-Object System.Collections.Generic.List[string]
    foreach ($h in $check.HardStops) { $hardStops.Add($h) }
    foreach ($w in $check.Warnings) { $warnings.Add($w) }

    $byDomainDup = $Projects | Group-Object CanonicalCode | Where-Object { $_.Count -gt 1 }
    foreach ($g in $byDomainDup) { $hardStops.Add("Duplicate canonical code after apply: $($g.Name)") }

    if ($CreateDomainCanvas -and (Test-Path -LiteralPath $DomainCanvasPath)) {
        $canvasObj = Get-Utf8Content $DomainCanvasPath | ConvertFrom-Json
        $textNodes = @($canvasObj.nodes | Where-Object { $_.type -eq "text" -and $_.text })
        $dupes = @()
        foreach ($p in $Projects) {
            $count = @($textNodes | Where-Object { $_.text -like "*$($p.CanonicalCode)*" }).Count
            if ($count -ne 1) { $dupes += "$($p.CanonicalCode) appears $count times" }
        }
        foreach ($d in $dupes) { $hardStops.Add("Canvas card check failed: $d") }
    }

    $projectKnowledgeGeneric = @($DomainModelPath, $DomainMatrixPath, $MemoryIndexPath, $RegistryPath, $AliasMapPath, $NamingDictionaryPath) | Where-Object { Test-Path -LiteralPath $_ } | ForEach-Object { Select-String -Path $_ -Pattern "generated project knowledge content|PROJECT_NAME|PASTE UPDATE HERE|INTAKE_FILE.md" -SimpleMatch -ErrorAction SilentlyContinue }
    if (@($projectKnowledgeGeneric).Count -gt 0) { $hardStops.Add("Placeholder/generic marker text found in active source-of-truth.") }

    if (($Projects | Where-Object { $_.CanonicalCode -eq "PPJ.InvoiceDownloader.v1.2" }).PrimaryDomain -ne "Finance / Accounting") { $hardStops.Add("PPJ.InvoiceDownloader is not Finance / Accounting.") }
    if (($Projects | Where-Object { $_.CanonicalCode -eq "PPJ.AI.Hub.v2.1" }).PrimaryDomain -ne "Internal Chatbot & AI Platforms") { $hardStops.Add("PPJ.AI.Hub domain boundary failed.") }
    if (($Projects | Where-Object { $_.CanonicalCode -eq "PPJ.PERRI.Chatbot.v3.2" }).PrimaryDomain -ne "Internal Chatbot & AI Platforms") { $hardStops.Add("PPJ.PERRI domain boundary failed.") }
    if (($Projects | Where-Object { $_.CanonicalCode -eq "PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0" }).PrimaryDomain -ne "Internal Chatbot & AI Platforms") { $hardStops.Add("PPJ.GLPI domain boundary failed.") }

    return [pscustomobject]@{ HardStops = @($hardStops); Warnings = @($warnings) }
}

function Build-OperationLog {
    param([object[]]$Results, [object]$Validation)
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# Domain Model Update Log")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Timestamp: $Stamp")
    [void]$sb.AppendLine("Vault: $VaultRoot")
    [void]$sb.AppendLine("Backup: $BackupRoot")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Results")
    foreach ($r in $Results) { [void]$sb.AppendLine("- [$($r.Action)] $($r.File) - $($r.Label)") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Validation")
    [void]$sb.AppendLine("Hard Stops: $($Validation.HardStops.Count)")
    foreach ($h in $Validation.HardStops) { [void]$sb.AppendLine("- $h") }
    [void]$sb.AppendLine("Warnings: $($Validation.Warnings.Count)")
    foreach ($w in $Validation.Warnings) { [void]$sb.AppendLine("- $w") }
    return $sb.ToString()
}

function Build-FinalReport {
    param([object[]]$Results, [object]$Validation)
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# Domain Model and Canvas Update Report")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Date: $Today")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Executive Summary")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Applied the official Primary Domain model for PPJ portfolio governance. Primary Domain is based on business owner, primary users, and primary capability. Lifecycle and progress remain separate.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Domain Model Applied")
    foreach ($d in $Domains) { [void]$sb.AppendLine("- $($d.Name): $($d.Capability)") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Canonical Code Corrections")
    foreach ($c in $CanonicalCorrections) { [void]$sb.AppendLine("- $($c.Old) -> $($c.New): $($c.Reason)") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Current File vs Canonical Code Mapping")
    foreach ($p in $Projects) { [void]$sb.AppendLine("- $($p.CurrentFile) -> $($p.CanonicalCode)") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Projects by Domain")
    foreach ($d in $Domains) { [void]$sb.AppendLine("- $($d.Name): $(@($Projects | Where-Object { $_.PrimaryDomain -eq $d.Name }).Count)") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Lifecycle and Progress Separation")
    [void]$sb.AppendLine("Lifecycle values are stored separately from progress. Percentages are stored only as Progress.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Cross-Functional Secondary Tags")
    [void]$sb.AppendLine("Secondary domains are tags only and do not duplicate project cards across domains.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Missing Official Project Notes")
    $missing = @($Projects | Where-Object { -not (Test-Path -LiteralPath (Join-Path $VaultRoot ("03_Projects\" + $_.CurrentFile))) })
    if ($missing.Count -eq 0) { [void]$sb.AppendLine("- None") } else { foreach ($m in $missing) { [void]$sb.AppendLine("- $($m.CurrentFile)") } }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Alias Map Updates")
    [void]$sb.AppendLine("Alias overlay updated when -UpdateAliasMap was provided.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Memory Updates")
    [void]$sb.AppendLine("Memory cards updated when -UpdateMemory was provided.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Registry Updates")
    [void]$sb.AppendLine("Registry, memory index, and naming dictionary overlays updated when -UpdateRegistry was provided.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Project Note Updates")
    if ($UpdateProjectNotes) { [void]$sb.AppendLine("Project note managed domain blocks updated.") } else { [void]$sb.AppendLine("Skipped; -UpdateProjectNotes was not provided.") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Resource Matrix Updates")
    [void]$sb.AppendLine("Resource matrix domain overlay updated when -UpdateResourceMatrix was provided.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Canvas Created")
    if ($CreateDomainCanvas) { [void]$sb.AppendLine("- 03_Projects/Canvas/PPJ_Domain_Encapsulation.canvas") } else { [void]$sb.AppendLine("- Skipped") }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Hard Stops")
    if ($Validation.HardStops.Count -eq 0) { [void]$sb.AppendLine("- None") } else { foreach ($h in $Validation.HardStops) { [void]$sb.AppendLine("- $h") } }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Validation Results")
    [void]$sb.AppendLine("- Domain duplication check completed.")
    [void]$sb.AppendLine("- Canvas JSON check completed if Canvas was created.")
    [void]$sb.AppendLine("- Boundary checks completed.")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Remaining Warnings")
    if ($Validation.Warnings.Count -eq 0) { [void]$sb.AppendLine("- None") } else { foreach ($w in $Validation.Warnings) { [void]$sb.AppendLine("- $w") } }
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## Next Recommended Step")
    [void]$sb.AppendLine("Review the new Domain Encapsulation Canvas and approve any later canonical file renames separately if desired.")
    return $sb.ToString()
}

$planCheck = Test-PlanHardStops
if ($DryRun) {
    Write-DryRunPreview -PlanCheck $planCheck
    if ($planCheck.HardStops.Count -gt 0) { exit 2 }
    exit 0
}

if ($planCheck.HardStops.Count -gt 0) {
    Write-Host "Hard stops detected. Apply blocked."
    foreach ($h in $planCheck.HardStops) { Write-Host "- $h" }
    exit 2
}

Invoke-Apply
