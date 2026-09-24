#!/usr/bin/env python3
import json, pathlib, re, sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
errors=[]; warnings=[]
snap=ROOT/'03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260824.json'
try:
    data=json.loads(snap.read_text(encoding='utf-8-sig'))
except Exception as e:
    errors.append(f"snapshot JSON: {e}"); data={'projects':[]}
codes=[p['code'] for p in data.get('projects',[]) if not p.get('candidate')]
if len(codes)!=len(set(codes)): errors.append('duplicate canonical codes in snapshot')
for path in ROOT.rglob('*'):
    if not path.is_file() or '99_Attachments' in path.parts or '.venv' in path.parts: continue
    if path.suffix.lower() not in ('.md','.canvas','.json','.py','.ps1','.txt'): continue
    try: raw=path.read_bytes(); text=raw.decode('utf-8-sig')
    except UnicodeDecodeError: errors.append(f'not UTF-8: {path.relative_to(ROOT)}'); continue
    placeholder_exempt=(path.name in ('README_PPJ_OBSIDIAN_SYSTEM.md.md','AGENTS.md','PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260824.md','PLACEHOLDER_PROJECT_CLEANUP_REPORT_20260628.md')
                        or any(part in ('_Templates','_Archive','.github') for part in path.parts))
    if path.suffix in ('.md','.canvas') and not placeholder_exempt:
        for marker in ('PROJECT_NAME','PASTE UPDATE HERE','INTAKE_FILE.md'):
            if marker in text: warnings.append(f'legacy placeholder {marker}: {path.relative_to(ROOT)}')
    if path.suffix=='.canvas':
        try:
            doc=json.loads(text)
            ids=[n.get('id') for n in doc.get('nodes',[])]
            if len(ids)!=len(set(ids)): errors.append(f'duplicate canvas node ids: {path.relative_to(ROOT)}')
            files=[n.get('file') for n in doc.get('nodes',[]) if n.get('type')=='file']
            if len(files)!=len(set(files)): errors.append(f'duplicate canvas file cards: {path.relative_to(ROOT)}')
        except Exception as e: errors.append(f'invalid canvas JSON {path.relative_to(ROOT)}: {e}')
for path in ROOT.rglob('*.md'):
    if '99_Attachments' in path.parts: continue
    text=path.read_text(encoding='utf-8-sig')
    if text.count('<!-- PPJ_PROJECT_KNOWLEDGE_START -->')!=text.count('<!-- PPJ_PROJECT_KNOWLEDGE_END -->'):
        errors.append(f'unpaired project knowledge markers: {path.relative_to(ROOT)}')
for forbidden in ('Warehouse.AWB.OCR.v','CPD.Pattern.Generation.v'):
    if any(forbidden in c for c in codes): errors.append(f'invented canonical code: {forbidden}')
fd=next((p for p in data.get('projects',[]) if p['code']=='FD.Datamart.v2.2'),{})
cpd=next((p for p in data.get('projects',[]) if p['code']=='CPD.Datamart.v1.1'),{})
if 'Hanger' not in fd.get('outcome','') or '3D' not in cpd.get('outcome',''): errors.append('FD/CPD scope separation failed')
report=ROOT/'10_Reports/PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260824.md'
report.write_text('# PPJ Portfolio Consistency Audit - 2026-08-24\n\n'
                  f'- Result: **{"PASS" if not errors else "FAIL"}**\n- Errors: {len(errors)}\n- Warnings: {len(warnings)}\n\n'
                  '## Errors\n\n'+('\n'.join(f'- {x}' for x in errors) or '- None')+'\n\n## Warnings\n\n'
                  +('\n'.join(f'- {x}' for x in warnings[:200]) or '- None')+'\n',encoding='utf-8')
print(f"Audit {'PASS' if not errors else 'FAIL'}: {len(errors)} errors, {len(warnings)} warnings")
print(report)
sys.exit(1 if errors else 0)
