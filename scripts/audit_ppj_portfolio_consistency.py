#!/usr/bin/env python3
import json, pathlib, re, sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
errors=[]; warnings=[]
snap=ROOT/'03_Projects/_Registry/Portfolio_Snapshots/PPJ_PORTFOLIO_SNAPSHOT_20260918.json'
try:
    data=json.loads(snap.read_text(encoding='utf-8-sig'))
except Exception as e:
    errors.append(f"snapshot JSON: {e}"); data={'projects':[]}
codes=[p['code'] for p in data.get('projects',[]) if not p.get('candidate')]
if len(codes)!=len(set(codes)): errors.append('duplicate canonical codes in snapshot')
standard=re.compile(r'^[A-Z]+_[A-Za-z0-9]+_v\d+\.\d+\.\d+$')
for c in codes:
    if '_' in c and not standard.match(c): errors.append(f'canonical code breaks naming standard: {c}')
seen={}
for p in data.get('projects',[]):
    for alias in p.get('legacy',[]):
        if alias in seen and seen[alias]!=p['code']: errors.append(f'alias {alias!r} maps to {seen[alias]} and {p["code"]}')
        seen[alias]=p['code']
for p in data.get('projects',[]):
    if p.get('root_file') and not (ROOT/'03_Projects'/p['root_file']).exists(): errors.append(f'missing root file: {p["code"]} -> {p["root_file"]}')
for path in ROOT.rglob('*'):
    if not path.is_file() or '99_Attachments' in path.parts or '.venv' in path.parts: continue
    if path.suffix.lower() not in ('.md','.canvas','.json','.py','.ps1','.txt'): continue
    try: raw=path.read_bytes(); text=raw.decode('utf-8-sig')
    except UnicodeDecodeError: errors.append(f'not UTF-8: {path.relative_to(ROOT)}'); continue
    placeholder_exempt=(path.name in ('README_PPJ_OBSIDIAN_SYSTEM.md.md','AGENTS.md','PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260918.md','PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260824.md','PLACEHOLDER_PROJECT_CLEANUP_REPORT_20260628.md')
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
fd=next((p for p in data.get('projects',[]) if p['code']=='FAB_FabricDatamart_v2.2.0'),{})
cpd=next((p for p in data.get('projects',[]) if p['code']=='CPD_VisualSampleDatamart_v1.1.0'),{})
if 'Hanger' not in fd.get('outcome','') or '3D' not in cpd.get('outcome',''): errors.append('FAB/CPD scope separation failed')
canvas=ROOT/'03_Projects/Canvas/PPJ_Executive_Board_v2.canvas'
if canvas.exists():
    text=canvas.read_text(encoding='utf-8-sig')
    marks=re.findall(r'PPJ_PROJECT_CARD:([^ >]+(?: [^ >]+)*?) -->',text)
    if sorted(marks)!=sorted(codes): errors.append('Executive Board cards do not match the registered codes in the snapshot')
report=ROOT/'10_Reports/PPJ_PORTFOLIO_CONSISTENCY_AUDIT_20260918.md'
report.write_text('# PPJ Portfolio Consistency Audit - 2026-09-18\n\n'
                  f'- Result: **{"PASS" if not errors else "FAIL"}**\n- Errors: {len(errors)}\n- Warnings: {len(warnings)}\n\n'
                  '## Errors\n\n'+('\n'.join(f'- {x}' for x in errors) or '- None')+'\n\n## Warnings\n\n'
                  +('\n'.join(f'- {x}' for x in warnings[:200]) or '- None')+'\n',encoding='utf-8')
print(f"Audit {'PASS' if not errors else 'FAIL'}: {len(errors)} errors, {len(warnings)} warnings")
print(report)
sys.exit(1 if errors else 0)
