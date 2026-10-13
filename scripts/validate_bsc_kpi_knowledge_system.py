from __future__ import annotations

import argparse
import html
import json
import re
from pathlib import Path


VAULT = Path(__file__).resolve().parents[1]
BASE = VAULT / "03_Projects" / "Canvas" / "BSC_KPI_Performance_Assessment"
VALIDATION = BASE / "Validation"

REQUIRED_CANVASES = [
    "Presentation/BSC_KPI_Executive_Assessment_v1_0.canvas",
    "Mindmaps/BSC_KPI_Enterprise_Master_Mindmap_v1_0.canvas",
    "Mindmaps/01_ASIS_Current_State.canvas",
    "Mindmaps/02_Pain_Points_Impact.canvas",
    "Mindmaps/03_Root_Cause_Analysis.canvas",
    "Mindmaps/04_TOBE_Target_Process.canvas",
    "Mindmaps/05_SOP_JD_KPI_Relationships.canvas",
    "Mindmaps/06_Performance_Hierarchy.canvas",
    "Mindmaps/07_Work_Done_Measurement.canvas",
    "Mindmaps/08_Challenges_Gap_Analysis.canvas",
    "Mindmaps/09_Discovery_Plan.canvas",
    "Mindmaps/10_Requirements_Traceability.canvas",
    "Mindmaps/11_Management_Decisions.canvas",
]

REQUIRED_REGISTERS = [
    "Registers/Evidence_Register.md",
    "Registers/Pain_Point_Register.md",
    "Registers/Gap_Register.md",
    "Registers/Requirement_Register.md",
    "Registers/Open_Question_Register.md",
    "Registers/Decision_Log.md",
    "Registers/Business_Rule_Candidates.md",
    "Registers/Risk_Register.md",
    "Registers/Stakeholder_Map.md",
]

COLORS = {
    "1": "#7f3542",
    "2": "#9a642b",
    "3": "#8a7427",
    "4": "#2f7360",
    "5": "#315f80",
    "6": "#66538a",
    "": "#46515a",
}


def load_canvas(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def node_text(node: dict) -> str:
    if node.get("type") == "text":
        return node.get("text", "")
    if node.get("type") == "file":
        return node.get("file", "")
    if node.get("type") == "group":
        return node.get("label", "")
    return ""


def rect(node: dict) -> tuple[float, float, float, float]:
    return float(node["x"]), float(node["y"]), float(node["width"]), float(node["height"])


def overlap_ratio(a: dict, b: dict) -> float:
    ax, ay, aw, ah = rect(a)
    bx, by, bw, bh = rect(b)
    ix = max(0.0, min(ax + aw, bx + bw) - max(ax, bx))
    iy = max(0.0, min(ay + ah, by + bh) - max(ay, by))
    inter = ix * iy
    if not inter:
        return 0.0
    return inter / min(aw * ah, bw * bh)


def inspect_canvas(path: Path) -> dict:
    issues: list[str] = []
    data = load_canvas(path)
    nodes = data.get("nodes", [])
    edges = data.get("edges", [])
    ids = [n.get("id") for n in nodes]
    if len(ids) != len(set(ids)):
        issues.append("duplicate node IDs")
    edge_ids = [e.get("id") for e in edges]
    if len(edge_ids) != len(set(edge_ids)):
        issues.append("duplicate edge IDs")
    node_ids = set(ids)
    for edge in edges:
        if edge.get("fromNode") not in node_ids or edge.get("toNode") not in node_ids:
            issues.append(f"dangling edge {edge.get('id')}")
    broken_files: list[str] = []
    for node in nodes:
        for key in ("x", "y", "width", "height"):
            if not isinstance(node.get(key), (int, float)):
                issues.append(f"invalid geometry {node.get('id')}:{key}")
        if node.get("type") == "file":
            target = VAULT / node.get("file", "")
            if not target.exists():
                broken_files.append(node.get("file", ""))
    if broken_files:
        issues.extend([f"missing file node: {item}" for item in broken_files])

    content_nodes = [n for n in nodes if n.get("type") != "group"]
    overlaps: list[str] = []
    for i, left in enumerate(content_nodes):
        for right in content_nodes[i + 1:]:
            if overlap_ratio(left, right) > 0.08:
                overlaps.append(f"{left['id']} <-> {right['id']}")
    if overlaps:
        issues.extend([f"content overlap: {item}" for item in overlaps])

    return {
        "nodes": len(nodes),
        "edges": len(edges),
        "file_nodes": sum(1 for n in nodes if n.get("type") == "file"),
        "issues": issues,
        "overlaps": overlaps,
        "data": data,
    }


def contains_all(path: Path, terms: list[str]) -> bool:
    text = path.read_text(encoding="utf-8-sig").casefold()
    return all(term.casefold() in text for term in terms)


def canvas_has_file(canvas_data: dict, suffix: str) -> bool:
    suffix = suffix.replace("\\", "/")
    return any(n.get("type") == "file" and n.get("file", "").replace("\\", "/").endswith(suffix) for n in canvas_data.get("nodes", []))


def svg_preview(data: dict, output: Path, title: str) -> None:
    nodes = data["nodes"]
    min_x = min(n["x"] for n in nodes) - 100
    min_y = min(n["y"] for n in nodes) - 100
    max_x = max(n["x"] + n["width"] for n in nodes) + 100
    max_y = max(n["y"] + n["height"] for n in nodes) + 100
    vb_w, vb_h = max_x - min_x, max_y - min_y
    edge_parts: list[str] = []
    node_by_id = {n["id"]: n for n in nodes}
    for edge in data.get("edges", []):
        a = node_by_id[edge["fromNode"]]
        b = node_by_id[edge["toNode"]]
        x1, y1 = a["x"] + a["width"] / 2, a["y"] + a["height"] / 2
        x2, y2 = b["x"] + b["width"] / 2, b["y"] + b["height"] / 2
        color = COLORS.get(str(edge.get("color", "")), "#73808a")
        edge_parts.append(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{color}" stroke-width="8" opacity="0.55" marker-end="url(#arrow)"/>')
    node_parts: list[str] = []
    for node in nodes:
        x, y, w, h = rect(node)
        color = COLORS.get(str(node.get("color", "")), "#46515a")
        if node.get("type") == "group":
            node_parts.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="35" fill="none" stroke="{color}" stroke-width="10" stroke-dasharray="28 20" opacity="0.75"/>')
            label = html.escape(node.get("label", ""))
            node_parts.append(f'<text x="{x + 32}" y="{y + 54}" fill="#dfe7ec" font-family="Segoe UI,Arial" font-size="34" font-weight="700">{label}</text>')
            continue
        fill = "#1f2930" if node.get("type") == "text" else "#27343c"
        node_parts.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="28" fill="{fill}" stroke="{color}" stroke-width="10"/>')
        raw_lines = [re.sub(r"^[#*`|>\- ]+", "", line).strip() for line in node_text(node).splitlines()]
        lines = [line for line in raw_lines if line][:7]
        font_size = max(24, min(42, int(w / 18)))
        for idx, line in enumerate(lines):
            if len(line) > 54:
                line = line[:51] + "..."
            weight = "700" if idx == 0 else "400"
            node_parts.append(f'<text x="{x + 28}" y="{y + 55 + idx * (font_size + 9)}" fill="#edf2f5" font-family="Segoe UI,Arial" font-size="{font_size}" font-weight="{weight}">{html.escape(line)}</text>')
    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="2400" height="1600" viewBox="{min_x} {min_y} {vb_w} {vb_h}">
<title>{html.escape(title)}</title>
<defs><marker id="arrow" markerWidth="12" markerHeight="12" refX="10" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#8d9aa4"/></marker></defs>
<rect x="{min_x}" y="{min_y}" width="{vb_w}" height="{vb_h}" fill="#11171b"/>
{''.join(edge_parts)}
{''.join(node_parts)}
</svg>'''
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(svg, encoding="utf-8", newline="\n")


def status(ok: bool) -> str:
    return "PASS" if ok else "FAIL"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--visual-inspected", action="store_true", help="Record that generated SVG previews were visually inspected.")
    args = parser.parse_args()

    VALIDATION.mkdir(parents=True, exist_ok=True)
    missing_required = [p for p in [*REQUIRED_CANVASES, *REQUIRED_REGISTERS, "00_INDEX.md"] if not (BASE / p).exists()]
    canvas_results: dict[str, dict] = {}
    for rel_path in REQUIRED_CANVASES:
        path = BASE / rel_path
        if path.exists():
            canvas_results[rel_path] = inspect_canvas(path)

    all_structural = not missing_required and all(not item["issues"] for item in canvas_results.values())
    presentation = canvas_results.get(REQUIRED_CANVASES[0], {}).get("data", {})
    master = canvas_results.get(REQUIRED_CANVASES[1], {}).get("data", {})

    presentation_groups = [n for n in presentation.get("nodes", []) if n.get("type") == "group"]
    presentation_has_12 = len(presentation_groups) == 12 and all(f"{i:02d} -" in " ".join(n.get("label", "") for n in presentation_groups) for i in range(1, 13))
    executive_navigation = canvas_has_file(presentation, "Mindmaps/BSC_KPI_Enterprise_Master_Mindmap_v1_0.canvas")
    domain_navigation = all(canvas_has_file(master, f"Mindmaps/{name}.canvas") for name in [
        "01_ASIS_Current_State", "02_Pain_Points_Impact", "03_Root_Cause_Analysis", "04_TOBE_Target_Process",
        "05_SOP_JD_KPI_Relationships", "06_Performance_Hierarchy", "07_Work_Done_Measurement",
        "08_Challenges_Gap_Analysis", "09_Discovery_Plan", "11_Management_Decisions",
    ])
    pp003_trace = contains_all(BASE / "Registers/Pain_Point_Register.md", ["PP-003", "RC-002", "RC-004", "OQ-003", "WP01", "REQ-003"])
    sop_clear = contains_all(BASE / "Knowledge/07_SOP_JD_KPI_Conceptual_Model.md", ["CONCEPTUAL", "NOT A VERIFIED PPJ MAPPING", "many-to-many"])
    evidence_status = all(any(label in "\n".join(node_text(n) for n in item["data"].get("nodes", [])) for label in ["TO VERIFY", "PROPOSED", "PENDING", "REPORTED"]) for rel_path, item in canvas_results.items() if "Master" not in rel_path)
    hierarchy_clear = contains_all(BASE / "Knowledge/08_Performance_Hierarchy.md", ["Member", "Team", "Department", "Division", "Echelon / Corporate"])
    pain_canvas = canvas_results.get("Mindmaps/02_Pain_Points_Impact.canvas", {}).get("data", {})
    cross_domain = canvas_has_file(pain_canvas, "Registers/Risk_Register.md") and canvas_has_file(pain_canvas, "Mindmaps/09_Discovery_Plan.canvas") and contains_all(BASE / "Mindmaps/02_Pain_Points_Impact.canvas", ["PP-003"])
    source_integrity = all_structural and contains_all(BASE / "Knowledge/15_Source_Assessment_2026-10-13.md", ["NOT FOUND / NOT INSPECTED", "NOT AVAILABLE", "not independently verified"])
    extensibility = contains_all(BASE / "Knowledge/14_Traceability_Model.md", ["stable IDs", "Register updates preserve IDs", "Future BRD"])
    backlinks = all(canvas_has_file(item["data"], "Mindmaps/BSC_KPI_Enterprise_Master_Mindmap_v1_0.canvas") and canvas_has_file(item["data"], "00_INDEX.md") for rel_path, item in canvas_results.items() if rel_path.startswith("Mindmaps/") and "Master" not in rel_path)
    management_review = presentation_has_12 and contains_all(BASE / "Knowledge/02_Executive_Findings.md", ["Validate AS-IS", "Standardize definitions", "Evaluate options", "Approve scope"])

    tests = [
        ("TEST 01 - Executive Navigation", executive_navigation, "Presentation links to Master Mind Map."),
        ("TEST 02 - Domain Navigation", domain_navigation, "Master links to AS-IS, TO-BE, KPI, Challenges, Discovery and other submaps."),
        ("TEST 03 - Pain Point Traceability", pp003_trace, "PP-003 traces to impact, hypotheses, question, WP01 and REQ-003."),
        ("TEST 04 - SOP/JD/KPI Relationships", sop_clear, "Conceptual relationships are explicitly separated from verified PPJ mappings."),
        ("TEST 05 - Evidence Status", evidence_status, "Detailed canvases contain visible non-color status labels."),
        ("TEST 06 - Organizational Hierarchy", hierarchy_clear, "Member through Echelon/Corporate is present and explained."),
        ("TEST 07 - Cross-Domain Navigation", cross_domain, "Pain map links to risk and discovery material."),
        ("TEST 08 - Source Integrity", source_integrity, "All file nodes exist; missing transcript/system evidence is disclosed."),
        ("TEST 09 - Layout Quality", args.visual_inspected and all_structural, "SVG preview inspected; native Obsidian UI interaction not claimed."),
        ("TEST 10 - Extensibility", extensibility, "Stable-ID and register-extension rules are documented."),
        ("TEST 11 - Bidirectional Links", backlinks, "Every submap links back to Master and Index."),
        ("TEST 12 - Management Review", management_review, "12-frame presentation covers current findings, direction, risks and decisions."),
    ]

    if presentation:
        svg_preview(presentation, VALIDATION / "Presentation_Overview.svg", "BSC KPI Executive Presentation")
    if master:
        svg_preview(master, VALIDATION / "Master_Mindmap_Overview.svg", "BSC KPI Master Mind Map")
    preview_dir = VALIDATION / "Previews"
    for rel_path, item in canvas_results.items():
        preview_name = rel_path.replace("/", "__").replace(".canvas", ".svg")
        svg_preview(item["data"], preview_dir / preview_name, rel_path)

    lines = [
        "---",
        "type: canvas-validation-report",
        "title: \"BSC/KPI Knowledge System Validation Report\"",
        "last_updated: 2026-10-13",
        "---",
        "",
        "# BSC/KPI Knowledge System Validation Report",
        "",
        f"Overall structural result: **{status(all_structural)}**",
        "",
        "## Structural checks",
        "",
        "| Canvas | Nodes | Edges | File nodes | Result |",
        "| --- | ---: | ---: | ---: | --- |",
    ]
    for rel_path in REQUIRED_CANVASES:
        item = canvas_results.get(rel_path)
        if not item:
            lines.append(f"| {rel_path} | - | - | - | FAIL - missing |")
        else:
            result_text = "PASS" if not item["issues"] else "FAIL - " + "; ".join(item["issues"])
            lines.append(f"| {rel_path} | {item['nodes']} | {item['edges']} | {item['file_nodes']} | {result_text} |")
    lines += [
        "",
        "Checks include JSON parsing, unique node/edge IDs, valid geometry, valid edge references, existing file-node targets and non-overlapping content cards.",
        "",
        "## Required content",
        "",
        f"- Required Canvas files: **{status(not [p for p in missing_required if p.endswith('.canvas')])}**",
        f"- Required registers/index: **{status(not [p for p in missing_required if not p.endswith('.canvas')])}**",
        f"- Presentation has 12 numbered frames: **{status(presentation_has_12)}**",
        f"- Master-to-domain navigation: **{status(domain_navigation)}**",
        f"- Submap backlinks: **{status(backlinks)}**",
        "",
        "## Functional acceptance tests",
        "",
        "| Test | Result | Evidence |",
        "| --- | --- | --- |",
    ]
    for name, ok, evidence in tests:
        result_text = "PASS" if ok else ("NOT TESTED" if name.startswith("TEST 09") and not args.visual_inspected else "FAIL")
        lines.append(f"| {name} | **{result_text}** | {evidence} |")
    lines += [
        "",
        "## Visual QA boundary",
        "",
        "- `Presentation_Overview.svg`, `Master_Mindmap_Overview.svg` and `Previews/*.svg` are deterministic geometry previews.",
        "- A PASS for TEST 09 means those previews were visually inspected after zero automated overlap findings.",
        "- Native Obsidian click/hover/render behavior was not executed by this script and is not claimed.",
        "",
        "## Evidence limitations",
        "",
        "- October 12, 2026 transcript was not found.",
        "- TOP system access/configuration was not available.",
        "- Reported current-state items remain TO VERIFY; proposed architecture and rules remain NOT APPROVED.",
        "",
        "Back: [[03_Projects/Canvas/BSC_KPI_Performance_Assessment/00_INDEX|BSC/KPI Index]]",
    ]
    report = "\n".join(lines).strip() + "\n"
    (VALIDATION / "VALIDATION_REPORT.md").write_text(report, encoding="utf-8", newline="\n")

    failures = [name for name, ok, _ in tests if not ok and not (name.startswith("TEST 09") and not args.visual_inspected)]
    print(f"Structural: {status(all_structural)}")
    print(f"Canvas files validated: {len(canvas_results)}/{len(REQUIRED_CANVASES)}")
    print(f"Functional failures: {len(failures)}")
    for failure in failures:
        print(f"FAIL: {failure}")
    print(f"Report: {(VALIDATION / 'VALIDATION_REPORT.md').relative_to(VAULT)}")
    return 1 if (not all_structural or failures) else 0


if __name__ == "__main__":
    raise SystemExit(main())
