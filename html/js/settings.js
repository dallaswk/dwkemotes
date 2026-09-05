/**
 * dwkemotes - Panel de ajustes
 * -----------------------------------------------------------------------------
 * Todo lo que aqui se cambia es del jugador: se guarda en su cliente y se aplica
 * en caliente sin volver a pedir datos a Lua. config.lua solo decide los valores
 * de partida para quien nunca ha tocado nada.
 */
const Settings = {
    WALKLOCK_SWITCH_ID: 'walklock-switch',

    _panel: null,
    _bodyEl: null,
    _open: false,

    init() {
        this._panel = document.getElementById('settings-panel');
        this._bodyEl = document.getElementById('settings-body');

        document.getElementById('settings-btn').addEventListener('click', () => this.toggle());
        document.getElementById('settings-close').addEventListener('click', () => this.close());
    },

    toggle() {
        this._open ? this.close() : this.open();
    },

    open() {
        this._open = true;
        this._render();
        this._panel.classList.remove('hidden');
        document.getElementById('settings-btn').classList.add('active');
    },

    close() {
        this._open = false;
        this._panel.classList.add('hidden');
        document.getElementById('settings-btn').classList.remove('active');
        NUI.searchBlur();
    },

    isOpen() {
        return this._open;
    },

    /**
     * Pone el interruptor de "caminar con la animacion" en el estado que dice
     * Lua. Se toca solo ese control en vez de repintar el panel entero porque
     * un repintado devolveria el scroll de los ajustes al principio cada vez
     * que alguien pulsa /emotewalk.
     */
    syncWalkLock() {
        if (!this._open) return;
        const btn = document.getElementById(this.WALKLOCK_SWITCH_ID);
        if (!btn) return;
        btn.classList.toggle('on', Store.walkLock);
        btn.setAttribute('aria-checked', String(Store.walkLock));
    },

    // ─── Construccion de controles ───

    _render() {
        document.getElementById('settings-title').textContent = Store.t('settings');
        this._bodyEl.replaceChildren();

        const s = Store.settings;

        this._bodyEl.appendChild(this._section(Store.t('appearance'), [
            this._colorRow(Store.t('accentcolor'), s.accent, (value) => {
                Store.setSetting('accent', value);
                App.applySettings();
            }),
            this._segmentRow(Store.t('columns'), [1, 2, 3, 4], s.columns, (value) => {
                Store.setSetting('columns', value);
                App.applySettings({ relayout: true });
            }),
            this._sliderRow(Store.t('uiscale'), s.scale, 80, 130, 5, '%', (value) => {
                Store.setSetting('scale', value);
                App.applySettings({ relayout: true });
            }),
            this._toggleRow(Store.t('sidebarlabels'), s.showLabels, (value) => {
                Store.setSetting('showLabels', value);
                App.applySettings({ sidebar: true });
            }),
            this._toggleRow(Store.t('uianimations'), s.animations, (value) => {
                Store.setSetting('animations', value);
                App.applySettings();
            }),
        ]));

        const behaviour = [
            this._sliderRow(Store.t('previewdelay'), s.previewDelay, 0, 1500, 50, 'ms', (value) => {
                Store.setSetting('previewDelay', value);
            }, (value) => (value === 0 ? Store.t('disabled') : value + ' ms')),
            this._toggleRow(Store.t('showrecents'), s.showRecents, (value) => {
                Store.setSetting('showRecents', value);
                App.applySettings({ sidebar: true, order: true });
            }),
            this._toggleRow(Store.t('showmostused'), s.showMostUsed, (value) => {
                Store.setSetting('showMostUsed', value);
                App.applySettings({ sidebar: true, order: true });
            }),
            this._toggleRow(Store.t('confirmplay'), s.confirmPlay, (value) => {
                Store.setSetting('confirmPlay', value);
                App.applySettings();   // el pie gana o pierde el atajo de Enter
            }),
            this._hint(Store.t('confirmplayhint')),
        ];

        // "Caminar con la animacion" no es un ajuste de la interfaz: el estado
        // vive en Lua (se guarda en el cliente y sobrevive al cierre del menu),
        // asi que no pasa por Store.setSetting. La barra de estado y el chip se
        // actualizan solos cuando Lua responde con el estado nuevo.
        if (Store.walkLockAvailable) {
            behaviour.push(this._toggleRow(Store.t('walklock'), Store.walkLock, (value) => {
                NUI.setWalkLock(value);
            }, this.WALKLOCK_SWITCH_ID));
            behaviour.push(this._hint(Store.t('walklockhint')));
        }

        this._bodyEl.appendChild(this._section(Store.t('behaviour'), behaviour));

        this._bodyEl.appendChild(this._section(Store.t('data'), [
            this._buttonRow('download', Store.t('exportprofile'), () => this._export()),
            this._buttonRow('upload', Store.t('importprofile'), () => this._showImport()),
            this._buttonRow('trash', Store.t('clearusage'), () => this.clearUsage(), 'danger'),
            this._buttonRow('rotate', Store.t('resetsettings'), () => this._reset(), 'danger'),
        ]));

        const hint = document.createElement('p');
        hint.className = 'settings-hint';
        hint.textContent = Store.t('settingslocal');
        this._bodyEl.appendChild(hint);
    },

    _section(title, rows) {
        const section = document.createElement('div');
        section.className = 'settings-section';

        const heading = document.createElement('h4');
        heading.className = 'settings-heading';
        heading.textContent = title;
        section.appendChild(heading);

        for (const row of rows) section.appendChild(row);
        return section;
    },

    /** Nota explicativa bajo una fila de ajustes. */
    _hint(text) {
        const p = document.createElement('p');
        p.className = 'settings-hint';
        p.textContent = text;
        return p;
    },

    _row(label) {
        const row = document.createElement('div');
        row.className = 'settings-row';

        const text = document.createElement('span');
        text.className = 'settings-label';
        text.textContent = label;
        row.appendChild(text);

        return row;
    },

    _colorRow(label, current, onChange) {
        const row = this._row(label);
        const wrap = document.createElement('div');
        wrap.className = 'settings-colors';

        for (const color of Store.ACCENTS) {
            const dot = document.createElement('button');
            dot.type = 'button';
            dot.className = 'color-dot' + (color.toLowerCase() === String(current).toLowerCase() ? ' active' : '');
            dot.style.background = color;
            dot.setAttribute('aria-label', color);
            dot.onclick = () => {
                wrap.querySelectorAll('.color-dot').forEach(d => d.classList.toggle('active', d === dot));
                onChange(color);
            };
            wrap.appendChild(dot);
        }

        row.appendChild(wrap);
        return row;
    },

    _segmentRow(label, values, current, onChange) {
        const row = this._row(label);
        const group = document.createElement('div');
        group.className = 'segmented';

        for (const value of values) {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'segment' + (value === current ? ' active' : '');
            btn.textContent = String(value);
            btn.onclick = () => {
                group.querySelectorAll('.segment').forEach(b => b.classList.toggle('active', b === btn));
                onChange(value);
            };
            group.appendChild(btn);
        }

        row.appendChild(group);
        return row;
    },

    _sliderRow(label, current, min, max, step, unit, onChange, formatter) {
        const row = this._row(label);
        const wrap = document.createElement('div');
        wrap.className = 'settings-slider';

        const input = document.createElement('input');
        input.type = 'range';
        input.min = String(min);
        input.max = String(max);
        input.step = String(step);
        input.value = String(current);

        const value = document.createElement('span');
        value.className = 'slider-value';
        const format = formatter || ((v) => v + (unit || ''));
        value.textContent = format(Number(current));

        input.oninput = () => {
            const next = Number(input.value);
            value.textContent = format(next);
            onChange(next);
        };

        wrap.appendChild(input);
        wrap.appendChild(value);
        row.appendChild(wrap);
        return row;
    },

    _toggleRow(label, current, onChange, id) {
        const row = this._row(label);

        const btn = document.createElement('button');
        btn.type = 'button';
        if (id) btn.id = id;
        btn.className = 'switch' + (current ? ' on' : '');
        btn.setAttribute('role', 'switch');
        btn.setAttribute('aria-checked', String(!!current));

        const knob = document.createElement('span');
        knob.className = 'switch-knob';
        btn.appendChild(knob);

        btn.onclick = () => {
            const next = !btn.classList.contains('on');
            btn.classList.toggle('on', next);
            btn.setAttribute('aria-checked', String(next));
            onChange(next);
        };

        row.appendChild(btn);
        return row;
    },

    _buttonRow(iconName, label, onClick, variant) {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'settings-action' + (variant ? ' ' + variant : '');
        btn.appendChild(Icons.el(iconName, 'settings-action-icon'));

        const text = document.createElement('span');
        text.textContent = label;
        btn.appendChild(text);

        btn.onclick = onClick;
        return btn;
    },

    // ─── Acciones de datos ───

    _export() {
        Grid.copyText(Store.exportProfile());
        Toast.show(Store.t('profilecopied'), 'success');
    },

    _showImport() {
        this._bodyEl.replaceChildren();

        const heading = document.createElement('h4');
        heading.className = 'settings-heading';
        heading.textContent = Store.t('importprofile');
        this._bodyEl.appendChild(heading);

        const hint = document.createElement('p');
        hint.className = 'settings-hint';
        hint.textContent = Store.t('importhint');
        this._bodyEl.appendChild(hint);

        const area = document.createElement('textarea');
        area.className = 'settings-textarea';
        area.spellcheck = false;
        area.onfocus = () => NUI.searchFocus();
        area.onblur = () => NUI.searchBlur();
        this._bodyEl.appendChild(area);

        const actions = document.createElement('div');
        actions.className = 'settings-actions';

        const cancel = document.createElement('button');
        cancel.type = 'button';
        cancel.className = 'list-btn list-btn-cancel';
        cancel.textContent = Store.t('btn_back');
        cancel.onclick = () => this._render();
        actions.appendChild(cancel);

        const confirm = document.createElement('button');
        confirm.type = 'button';
        confirm.className = 'list-btn list-btn-save';
        confirm.textContent = Store.t('importprofile');
        confirm.onclick = () => {
            const result = Store.importProfile(area.value.trim());
            if (!result.ok) {
                Toast.show(Store.t('importfailed'), 'error');
                return;
            }
            Toast.show(Store.t('importok'), 'success');
            this._render();
            App.applySettings({ sidebar: true, order: true, relayout: true });
        };
        actions.appendChild(confirm);

        this._bodyEl.appendChild(actions);
        area.focus();
    },

    /** Borra el historial en el cliente y en Lua. */
    clearUsage() {
        NUI.clearUsage();
        Store.recents = [];
        Store.mostUsed = [];
        Toast.show(Store.t('usagecleared'), 'info');
        App.applySettings({ sidebar: true, order: true });
    },

    _reset() {
        Store.resetSettings();
        this._render();
        App.applySettings({ sidebar: true, order: true, relayout: true });
        Toast.show(Store.t('settingsreset'), 'info');
    }
};
