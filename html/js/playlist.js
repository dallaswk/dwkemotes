/**
 * dwkemotes - Editor de playlists
 * -----------------------------------------------------------------------------
 * Una playlist es una secuencia de animaciones con un tiempo por paso. Se guarda
 * del lado Lua (KVP), no aqui: tiene que poder lanzarse con el menu cerrado. Este
 * fichero es solo el editor.
 *
 * El reordenado va con eventos de raton a mano. No hay ninguna libreria en el
 * proyecto y no conviene meterla —el menu quito el CDN de Font Awesome justo para
 * no depender de nada externo—, y la lista de pasos es un DOM normal y corto, asi
 * que no hace falta pelearse con la rejilla virtualizada de grid.js.
 */
const PlaylistEditor = {
    _state: null,
    _drag: null,

    // La misma paleta que las listas personalizadas, para que el menu no tenga
    // dos juegos de colores distintos.
    get _colors() {
        return (typeof App !== 'undefined' && App._LIST_COLORS) || ['#019685'];
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Apertura y cierre
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * @param {string|null} id  null crea una playlist nueva
     * @param {object|null} autoAddItem  animacion que se anade nada mas abrir
     */
    open(id, autoAddItem) {
        const existing = id ? Store.getPlaylist(id) : null;

        this._state = {
            id: existing ? existing.id : null,
            name: existing ? existing.name : '',
            color: existing ? existing.color : this._colors[0],
            loop: existing ? !!existing.loop : false,
            // Copia profunda: si el jugador cancela, lo guardado no se toca.
            items: existing ? existing.items.map(it => ({ ...it })) : [],
        };

        if (autoAddItem) this._addItem(autoAddItem);

        const modal = document.getElementById('playlist-modal');
        const form = document.getElementById('playlist-modal-form');
        const confirm = document.getElementById('playlist-confirm-delete');
        if (!modal) return;

        form.classList.remove('hidden');
        confirm.classList.add('hidden');

        const icon = document.getElementById('playlist-modal-icon');
        icon.innerHTML = '';
        icon.appendChild(Icons.el('music', 'list-modal-icon-svg'));
        icon.style.color = this._state.color;

        document.getElementById('playlist-modal-title').textContent =
            existing ? Store.t('editplaylist') : Store.t('newplaylist');

        const nameInput = document.getElementById('playlist-name-input');
        nameInput.value = this._state.name;
        nameInput.placeholder = Store.t('playlistname');
        nameInput.oninput = () => { this._state.name = nameInput.value; };

        document.getElementById('playlist-loop-label').textContent = Store.t('playlistloop');
        document.getElementById('playlist-cancel-btn').textContent = Store.t('btn_back');
        document.getElementById('playlist-save-btn').textContent =
            existing ? Store.t('saveplaylist') : Store.t('createplaylist');

        const delBtn = document.getElementById('playlist-delete-btn');
        delBtn.textContent = Store.t('deleteplaylist');
        delBtn.classList.toggle('hidden', !existing);
        delBtn.onclick = () => this._showDeleteConfirm();

        document.getElementById('playlist-cancel-btn').onclick = () => this.close();
        document.getElementById('playlist-save-btn').onclick = () => this._save();

        this._renderColors();
        this._renderLoop();
        this._renderSteps();

        modal.classList.remove('hidden');
        // El foco va al nombre solo cuando esta vacio: al editar una que ya
        // existe, lo normal es venir a tocar los pasos, no a renombrarla.
        if (!this._state.name) setTimeout(() => nameInput.focus(), 50);
    },

    close() {
        const modal = document.getElementById('playlist-modal');
        if (modal) modal.classList.add('hidden');
        this._state = null;
        this._endDrag();
    },

    isOpen() {
        const modal = document.getElementById('playlist-modal');
        return !!modal && !modal.classList.contains('hidden');
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Anadir pasos desde fuera (menu contextual de una tarjeta)
    // ─────────────────────────────────────────────────────────────────────────

    /** Anade una animacion a una playlist ya guardada, sin abrir el editor. */
    addToPlaylist(playlistId, item) {
        const list = Store.getPlaylist(playlistId);
        if (!list) return;

        const max = Store.config.maxPlaylistItems || 64;
        if ((list.items || []).length >= max) {
            Toast.show(Store.t('maxplaylistitems'), 'warning');
            return;
        }

        const items = list.items.map(it => ({ ...it }));
        items.push(Store.newPlaylistItem(item));

        this._persist({ ...list, items }, () => {
            Toast.show(
                Store.t('addedtoplaylist').replace('%s', item.label || item.name).replace('%l', list.name),
                'success'
            );
        });
    },

    _addItem(item) {
        const max = Store.config.maxPlaylistItems || 64;
        if (this._state.items.length >= max) {
            Toast.show(Store.t('maxplaylistitems'), 'warning');
            return;
        }
        this._state.items.push(Store.newPlaylistItem(item));
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Pintado
    // ─────────────────────────────────────────────────────────────────────────

    _renderColors() {
        const picker = document.getElementById('playlist-color-picker');
        picker.innerHTML = '';

        for (const color of this._colors) {
            const dot = document.createElement('button');
            dot.type = 'button';
            dot.className = 'color-dot' + (color === this._state.color ? ' active' : '');
            dot.style.background = color;
            dot.onclick = () => {
                this._state.color = color;
                document.getElementById('playlist-modal-icon').style.color = color;
                this._renderColors();
            };
            picker.appendChild(dot);
        }
    },

    _renderLoop() {
        const btn = document.getElementById('playlist-loop-toggle');
        btn.classList.toggle('on', this._state.loop);
        btn.setAttribute('aria-checked', String(this._state.loop));
        btn.onclick = () => {
            this._state.loop = !this._state.loop;
            this._renderLoop();
        };
    },

    _renderSteps() {
        const wrap = document.getElementById('playlist-steps');
        const empty = document.getElementById('playlist-empty');
        wrap.innerHTML = '';

        if (this._state.items.length === 0) {
            empty.textContent = Store.t('emptyplaylist');
            empty.classList.remove('hidden');
            return;
        }
        empty.classList.add('hidden');

        this._state.items.forEach((item, index) => {
            wrap.appendChild(this._buildStep(item, index));
        });
    },

    _buildStep(item, index) {
        const row = document.createElement('div');
        row.className = 'playlist-step';
        row.dataset.index = String(index);

        const grip = document.createElement('span');
        grip.className = 'playlist-grip';
        grip.title = Store.t('playlistdrag');
        grip.appendChild(Icons.el('grip', 'playlist-grip-svg'));
        grip.addEventListener('mousedown', (e) => this._startDrag(e, index));
        row.appendChild(grip);

        const num = document.createElement('span');
        num.className = 'playlist-step-num';
        num.textContent = String(index + 1);
        row.appendChild(num);

        const label = document.createElement('span');
        label.className = 'playlist-step-label';
        label.textContent = item.label || item.name;
        label.title = item.label || item.name;
        row.appendChild(label);

        const secs = document.createElement('input');
        secs.type = 'number';
        secs.className = 'playlist-step-secs';
        secs.value = String(Math.round(item.duration / 100) / 10);
        secs.step = '0.5';
        secs.min = String((Store.config.playlistMinDuration || 500) / 1000);
        secs.max = String((Store.config.playlistMaxDuration || 60000) / 1000);
        secs.onchange = () => {
            const ms = Math.round(parseFloat(secs.value) * 1000);
            item.duration = this._clampDuration(ms);
            secs.value = String(Math.round(item.duration / 100) / 10);
        };
        // Sin esto el menu se cerraria al teclear, porque app.js escucha Escape y
        // las flechas para navegar la rejilla.
        secs.onkeydown = (e) => e.stopPropagation();
        row.appendChild(secs);

        const unit = document.createElement('span');
        unit.className = 'playlist-step-unit';
        unit.textContent = Store.t('playlistseconds');
        row.appendChild(unit);

        const dup = document.createElement('button');
        dup.type = 'button';
        dup.className = 'playlist-step-btn';
        dup.title = Store.t('playlistduplicate');
        dup.appendChild(Icons.el('copy', 'playlist-step-btn-svg'));
        dup.onclick = () => {
            this._state.items.splice(index + 1, 0, { ...item });
            this._renderSteps();
        };
        row.appendChild(dup);

        const del = document.createElement('button');
        del.type = 'button';
        del.className = 'playlist-step-btn playlist-step-btn-danger';
        del.title = Store.t('playlistremove');
        del.appendChild(Icons.el('trash', 'playlist-step-btn-svg'));
        del.onclick = () => {
            this._state.items.splice(index, 1);
            this._renderSteps();
        };
        row.appendChild(del);

        return row;
    },

    _clampDuration(ms) {
        const min = Store.config.playlistMinDuration || 500;
        const max = Store.config.playlistMaxDuration || 60000;
        if (!Number.isFinite(ms)) return Store.config.playlistDefaultDuration || 5000;
        return Math.min(max, Math.max(min, ms));
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Reordenado
    //
    // Se mueve el elemento del array, no el nodo: al soltar se vuelve a pintar
    // la lista entera. Son unas pocas filas, y asi el indice, la numeracion y el
    // orden guardado no pueden desincronizarse.
    // ─────────────────────────────────────────────────────────────────────────

    _startDrag(e, index) {
        e.preventDefault();

        const wrap = document.getElementById('playlist-steps');
        const row = wrap.children[index];
        if (!row) return;

        this._drag = { index, height: row.offsetHeight || 32, startY: e.clientY };
        row.classList.add('dragging');

        this._onMove = (ev) => this._onDragMove(ev);
        this._onUp = () => this._endDrag();
        document.addEventListener('mousemove', this._onMove);
        document.addEventListener('mouseup', this._onUp);
    },

    _onDragMove(e) {
        if (!this._drag) return;

        const moved = e.clientY - this._drag.startY;
        const steps = Math.round(moved / this._drag.height);
        if (steps === 0) return;

        const from = this._drag.index;
        const to = Math.min(this._state.items.length - 1, Math.max(0, from + steps));
        if (to === from) return;

        const [item] = this._state.items.splice(from, 1);
        this._state.items.splice(to, 0, item);

        this._drag.index = to;
        this._drag.startY = e.clientY;

        this._renderSteps();

        const wrap = document.getElementById('playlist-steps');
        const row = wrap && wrap.children[to];
        if (row) row.classList.add('dragging');
    },

    _endDrag() {
        if (this._onMove) document.removeEventListener('mousemove', this._onMove);
        if (this._onUp) document.removeEventListener('mouseup', this._onUp);
        this._onMove = null;
        this._onUp = null;

        if (!this._drag) return;
        this._drag = null;

        const wrap = document.getElementById('playlist-steps');
        if (wrap) {
            for (const row of wrap.children) row.classList.remove('dragging');
        }
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Guardar y borrar
    // ─────────────────────────────────────────────────────────────────────────

    _save() {
        const name = (this._state.name || '').trim();
        if (!name) {
            document.getElementById('playlist-name-input').focus();
            return;
        }

        this._persist({
            id: this._state.id,
            name,
            color: this._state.color,
            loop: this._state.loop,
            items: this._state.items,
        }, () => {
            Toast.show(Store.t('playlistsaved'), 'success');
            this.close();
        });
    },

    /** Manda la playlist a Lua y refresca la copia local con lo que responda. */
    _persist(playlist, onOk) {
        NUI.savePlaylist(playlist).then(resp => {
            if (!resp || !resp.ok) {
                Toast.show(resp && resp.reason ? resp.reason : Store.t('maxplaylists'), 'error');
                return;
            }

            Store.setPlaylists(resp.playlists);
            if (typeof App !== 'undefined') {
                App._buildSidebar();
                App._setActiveCategory(Store.currentCategory);
                App.refreshCurrentView();
            }
            if (onOk) onOk();
        });
    },

    _showDeleteConfirm() {
        const form = document.getElementById('playlist-modal-form');
        const confirm = document.getElementById('playlist-confirm-delete');

        document.getElementById('playlist-confirm-title').textContent =
            `${Store.t('deleteplaylist')} "${this._state.name}"?`;
        document.getElementById('playlist-confirm-msg').textContent = Store.t('cannotundo');

        const backBtn = document.getElementById('playlist-confirm-back');
        const yesBtn = document.getElementById('playlist-confirm-yes');
        backBtn.textContent = Store.t('btn_back');
        yesBtn.textContent = Store.t('confirmdelete');

        form.classList.add('hidden');
        confirm.classList.remove('hidden');

        backBtn.onclick = () => {
            confirm.classList.add('hidden');
            form.classList.remove('hidden');
        };

        yesBtn.onclick = () => {
            const id = this._state && this._state.id;
            if (!id) return this.close();

            NUI.deletePlaylist(id).then(resp => {
                if (resp && resp.playlists) Store.setPlaylists(resp.playlists);
                this.close();
                if (typeof App !== 'undefined') {
                    App._buildSidebar();
                    App._setActiveCategory(Store.currentCategory);
                    App.refreshCurrentView();
                }
            });
        };
    },
};
