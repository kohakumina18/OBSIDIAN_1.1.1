'use strict';
/*
 * PPJ Canvas Focus
 *
 * Overview first, detail on demand - for ONE canvas only:
 *   03_Projects/Canvas/PPJ_Digital_Application_AI_Automation_Ecosystem.canvas
 *
 * - Project-to-module lines are hidden (presentation mode) or faint (editing mode).
 * - Hover a project: its modules / systems light up with their lines and labels; everything else fades.
 * - Hover a WFX / GTAS / third-party / data node: the projects related to it light up.
 * - Click pins the focus; Esc or a click on the background clears it.
 * - Node roles (project, WFX module, GTAS app, ...) get classes that styles.css uses for executive typography.
 *
 * Canvas JSON has no conditional visibility, so this works on the live canvas objects (canvas.nodes / canvas.edges,
 * node.nodeEl, edge.lineGroupEl / lineEndGroupEl / labelElement.wrapperEl) and only ever adds or removes CSS
 * classes: it never writes the canvas file, never cancels an event, and leaves dragging, zooming, selecting and
 * editing to Obsidian. Node roles come from the ids written by scripts/build_ppj_ecosystem_canvas.py.
 */
const { Plugin, Notice } = require('obsidian');

const TARGET = 'PPJ_Digital_Application_AI_Automation_Ecosystem.canvas';
const MODE_KEY = 'ppj-canvas-focus-mode';
const CLICK_SLOP_PX = 5;           // further than this between press and release is a drag / pan, not a click
const ROLES = ['project', 'core', 'wfx', 'gtas', 'system', 'title'];
const FOCUSABLE = new Set(['project', 'core', 'wfx', 'gtas', 'system']);
const EDGE_TYPES = ['integration', 'planned', 'data', 'knowledge', 'affinity'];
const MUTED_COLOURS = new Set(['2', '#8c8c8c']);   // On Hold (orange) and Closed (grey) project cards
// Module coverage badge written by the builder: first letter of a module's h1 (the core's h2). 3 live, 2 dev, 1 eval.
const BADGES = { '\u25cf': 3, '\u25d0': 2, '\u25cb': 1 };

function coverageOf(text, role) {
	const m = (role === 'core' ? /^## (.)/m : /^# (.)/).exec(text || '');
	return (m && BADGES[m[1]]) || 0;
}

function roleOf(id) {
	if (!id) return null;
	if (/^(proj|poc)-/.test(id)) return 'project';
	if (id === 'wfx-core') return 'core';
	if (/^wfx-/.test(id)) return 'wfx';
	if (/^gtas-/.test(id)) return 'gtas';
	if (/^(tp|data)-/.test(id) && id !== 'tp-note') return 'system';
	if (/^hdr-/.test(id)) return 'title';
	return null;
}

function dataOf(item) {
	try { return (item && item.getData && item.getData()) || {}; } catch (e) { return {}; }
}

function nodeId(node) {
	return node ? (node.id || dataOf(node).id) : null;
}

function edgeType(label) {
	const m = /^([A-Z]+)/.exec(label || '');
	const t = m ? m[1].toLowerCase() : '';
	return EDGE_TYPES.includes(t) ? t : 'other';
}

function edgeEls(edge) {
	return [edge.lineGroupEl, edge.lineEndGroupEl, edge.labelElement && edge.labelElement.wrapperEl].filter(Boolean);
}

function endNode(end) {
	return end ? end.node : null;
}

class FocusSession {
	constructor(plugin, view) {
		this.plugin = plugin;
		this.view = view;
		this.canvas = view.canvas;
		this.wrapper = this.canvas.wrapperEl;
		this.hovered = null;
		this.pinned = null;
		this.down = null;
		this.marked = new Set();
		this.elToNode = new Map();
		this.shape = '';

		this.onOver = this.onOver.bind(this);
		this.onLeave = this.onLeave.bind(this);
		this.onDown = this.onDown.bind(this);
		this.onClick = this.onClick.bind(this);
		// Capture phase, observe only: nothing here calls preventDefault / stopPropagation.
		this.wrapper.addEventListener('pointerover', this.onOver, true);
		this.wrapper.addEventListener('pointerleave', this.onLeave);
		this.wrapper.addEventListener('pointerdown', this.onDown, true);
		this.wrapper.addEventListener('click', this.onClick, true);

		this.wrapper.classList.add('ppj-focus-canvas');
		this.setMode(plugin.mode);
		this.refresh();
	}

	setMode(mode) {
		this.wrapper.classList.toggle('ppj-mode-presentation', mode !== 'editing');
		this.wrapper.classList.toggle('ppj-mode-editing', mode === 'editing');
	}

	/* (Re)classify every node and edge. Cheap (a few hundred elements); run whenever the canvas may have changed. */
	refresh() {
		this.elToNode.clear();
		for (const node of this.canvas.nodes.values()) {
			const el = node.nodeEl;
			if (!el) continue;
			this.elToNode.set(el, node);
			const role = roleOf(nodeId(node));
			el.classList.add('ppj-n');
			for (const r of ROLES) el.classList.toggle('ppj-r-' + r, r === role);
			const data = dataOf(node);
			el.classList.toggle('ppj-muted', role === 'project' && MUTED_COLOURS.has(data.color));
			const cov = role === 'wfx' || role === 'gtas' || role === 'core' ? coverageOf(data.text, role) : 0;
			for (const c of [1, 2, 3]) el.classList.toggle('ppj-cov-' + c, cov === c);
		}
		for (const edge of this.canvas.edges.values()) {
			const type = edgeType(dataOf(edge).label);
			const relation = roleOf(nodeId(endNode(edge.from))) === 'project' || roleOf(nodeId(endNode(edge.to))) === 'project';
			for (const el of edgeEls(edge)) {
				el.classList.add('ppj-e');
				for (const t of EDGE_TYPES) el.classList.toggle('ppj-t-' + t, t === type);
				el.classList.toggle('ppj-rel', relation);
				el.classList.toggle('ppj-found', !relation);
			}
		}
		this.shape = this.canvas.nodes.size + ':' + this.canvas.edges.size;
		// Objects may have been replaced (file reloaded): drop focus on nodes that no longer exist.
		const alive = new Set(this.canvas.nodes.values());
		if (this.pinned && !alive.has(this.pinned)) this.pinned = null;
		if (this.hovered && !alive.has(this.hovered)) this.hovered = null;
		this.apply(this.pinned || this.hovered);
	}

	stale() {
		return this.shape !== this.canvas.nodes.size + ':' + this.canvas.edges.size;
	}

	nodeFromEvent(e) {
		const t = e.target instanceof Element ? e.target : null;
		const el = t ? t.closest('.canvas-node') : null;
		if (!el || !this.wrapper.contains(el)) return null;
		let node = this.elToNode.get(el);
		if (!node || this.stale()) {
			this.refresh();
			node = this.elToNode.get(el);
		}
		return node && FOCUSABLE.has(roleOf(nodeId(node))) ? node : null;
	}

	onOver(e) {
		const node = this.nodeFromEvent(e);
		if (node === this.hovered) return;
		this.hovered = node;
		if (!this.pinned) this.apply(node);
	}

	onLeave() {
		this.hovered = null;
		if (!this.pinned) this.apply(null);
	}

	onDown(e) {
		this.down = { x: e.clientX, y: e.clientY };
	}

	onClick(e) {
		const d = this.down;
		this.down = null;
		if (!d || Math.hypot(e.clientX - d.x, e.clientY - d.y) > CLICK_SLOP_PX) return;   // drag or pan
		if (e.button !== 0 || e.detail > 1 || e.shiftKey || e.ctrlKey || e.metaKey || e.altKey) return;
		const t = e.target instanceof Element ? e.target : null;
		// Canvas chrome, edge labels and node menus / resizers are Obsidian's; leave focus alone.
		if (t && t.closest('.canvas-controls, .canvas-card-menu, .canvas-menu-container, .canvas-path-label-wrapper, ' +
			'.canvas-node-resizer, .menu, .modal-container')) return;
		const node = this.nodeFromEvent(e);
		this.pinned = node && node !== this.pinned ? node : null;   // same node again, or background: unpin
		this.apply(this.pinned || this.hovered);
	}

	reset() {
		this.pinned = null;
		this.hovered = null;
		this.apply(null);
	}

	apply(node) {
		for (const el of this.marked) el.classList.remove('ppj-self', 'ppj-related', 'ppj-on');
		this.marked.clear();
		this.wrapper.classList.toggle('ppj-focus-active', !!node);
		this.wrapper.classList.toggle('ppj-focus-pinned', !!node && node === this.pinned);
		if (!node) return;
		this.mark(node.nodeEl, 'ppj-self');
		for (const edge of this.canvas.edges.values()) {
			const from = endNode(edge.from);
			const to = endNode(edge.to);
			if (from !== node && to !== node) continue;
			for (const el of edgeEls(edge)) this.mark(el, 'ppj-on');
			const other = from === node ? to : from;
			if (other && other.nodeEl) this.mark(other.nodeEl, 'ppj-related');
		}
	}

	mark(el, cls) {
		if (!el) return;
		el.classList.add(cls);
		this.marked.add(el);
	}

	destroy() {
		this.apply(null);
		this.wrapper.removeEventListener('pointerover', this.onOver, true);
		this.wrapper.removeEventListener('pointerleave', this.onLeave);
		this.wrapper.removeEventListener('pointerdown', this.onDown, true);
		this.wrapper.removeEventListener('click', this.onClick, true);
		this.wrapper.classList.remove('ppj-focus-canvas', 'ppj-mode-presentation', 'ppj-mode-editing',
			'ppj-focus-active', 'ppj-focus-pinned');
	}
}

module.exports = class PPJCanvasFocus extends Plugin {
	async onload() {
		this.sessions = new Map();          // canvas view -> FocusSession
		this.timer = null;
		const saved = this.app.loadLocalStorage ? this.app.loadLocalStorage(MODE_KEY) : null;   // per device, not synced
		this.mode = saved === 'editing' ? 'editing' : 'presentation';

		this.addCommand({ id: 'toggle-mode', name: 'Toggle presentation / editing mode', callback: () => this.toggleMode() });
		this.addCommand({ id: 'clear-focus', name: 'Clear pinned focus', callback: () => this.sessions.forEach(s => s.reset()) });

		const scan = () => this.scan();
		this.registerEvent(this.app.workspace.on('layout-change', scan));
		this.registerEvent(this.app.workspace.on('active-leaf-change', scan));
		this.registerEvent(this.app.workspace.on('file-open', scan));
		// The builder rewrites the file when the portfolio changes; Obsidian then reloads the canvas objects.
		this.registerEvent(this.app.vault.on('modify', f => { if (f && f.name === TARGET) this.later(scan, 600); }));
		this.registerDomEvent(document, 'keydown', e => { if (e.key === 'Escape') this.sessions.forEach(s => s.reset()); });
		this.app.workspace.onLayoutReady(scan);
	}

	onunload() {
		if (this.timer) window.clearTimeout(this.timer);
		this.sessions.forEach(s => s.destroy());
		this.sessions.clear();
	}

	later(fn, ms) {
		if (this.timer) window.clearTimeout(this.timer);
		this.timer = window.setTimeout(() => { this.timer = null; fn(); }, ms);
	}

	scan() {
		const live = new Set();
		for (const leaf of this.app.workspace.getLeavesOfType('canvas')) {
			const view = leaf.view;
			if (!view || !view.canvas || !view.canvas.wrapperEl || !view.file || view.file.name !== TARGET) continue;
			live.add(view);
			const s = this.sessions.get(view);
			if (s && s.canvas === view.canvas) {
				s.refresh();
				continue;
			}
			if (s) s.destroy();
			this.sessions.set(view, new FocusSession(this, view));
		}
		for (const [view, s] of this.sessions) {
			if (!live.has(view)) {
				s.destroy();
				this.sessions.delete(view);
			}
		}
	}

	toggleMode() {
		this.mode = this.mode === 'editing' ? 'presentation' : 'editing';
		if (this.app.saveLocalStorage) this.app.saveLocalStorage(MODE_KEY, this.mode);
		this.sessions.forEach(s => s.setMode(this.mode));
		new Notice(this.mode === 'editing'
			? 'PPJ Canvas Focus: editing mode - relationship lines shown faintly'
			: 'PPJ Canvas Focus: presentation mode - lines only on hover / click');
	}
};

module.exports.__test__ = { FocusSession, roleOf, edgeType, coverageOf };
