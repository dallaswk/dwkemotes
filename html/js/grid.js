/**
 * dwkemotes - Rejilla virtualizada
 * -----------------------------------------------------------------------------
 * Dibuja solo las filas visibles y recicla las tarjetas en un pool, de modo que
 * una categoria con miles de emotes cuesta lo mismo que una con veinte.
 *
 * Diferencias con la version original:
 *   - Numero de columnas configurable (1-4) en vez de dos fijas.
 *   - Resaltado de las coincidencias de busqueda.
 *   - Retardo de vista previa configurable, incluido 0 para desactivarla.
 *   - Menu contextual con emote de grupo y colocacion en el mundo.
 */
const Grid = {
    ROW_GAP: 6,
    COL_GAP: 6,
    BUFFER: 6,
    MAX_POOL: 60,

    _scrollEl: null,
    _gridEl: null,
    _itemHeight: 34,
    _colWidth: 0,
    _cols: 2,
    _lastStart: -1,
    _lastEnd: -1,
    _scrollRAF: null,
    _hoverTimer: null,
    _progressBar: null,
    _activePreviewKey: null,
    _previewSuppressedUntil: 0,
    _postScrollTimer: null,
    _mouseX: 0,
    _mouseY: 0,
    _selectedIndex: -1,
    _rendered: new Map(),
    _pool: [],
    _emptyEl: null,
    _dropdown: null,
    _dropdownCloser: null,
    _ctxMenu: null,
    _ctxCloser: null,
    _tooltip: null,
    _usageTimer: null,
    _scrollByCategory: {},
    _scrollSaveTimer: null,
    _scrollRestoreTimer: null,

    init() {
        this._scrollEl = document.getElementById('content-scroll');
        this._gridEl = document.getElementById('emote-grid');
        this._scrollByCategory = Store.loadScrollPositions();

        SmoothScroll.init(this._scrollEl);

        this._tooltip = document.createElement('div');
        this._tooltip.className = 'cmd-tooltip';
        document.getElementById('emote-menu').appendChild(this._tooltip);

        this._scrollEl.addEventListener('mousemove', (e) => {
            this._mouseX = e.clientX;
            this._mouseY = e.clientY;
        });

        this._scrollEl.addEventListener('scroll', () => {
            this._rememberScroll();
            if (this._scrollRAF) return;
            this._scrollRAF = requestAnimationFrame(() => {
                this._scrollRAF = null;
                this._onScroll();
            });
        });

        window.addEventListener('resize', () => this.relayout());
    },

    /** Recalcula geometria y vuelve a pintar. Se llama al cambiar los ajustes. */
    relayout() {
        this._cols = Store.settings.columns || 2;
        this._measureColumns();
        this._measureItemHeight();
        this._lastStart = -1;
        this._lastEnd = -1;
        this._onScroll();
    },

    render() {
        this._cols = Store.settings.columns || 2;
        this._lastStart = -1;
        this._lastEnd = -1;
        this._selectedIndex = -1;
        this._previewSuppressedUntil = Date.now() + 250;
        this._cancelHover();
        this._closeDropdown();
        this._closeContextMenu();
        this._hideTooltip();
        this._clearRendered();
        this._hideEmpty();
        this._gridEl.style.height = '0px';
        SmoothScroll.reset();
        this._measureColumns();
        this._onScroll();
        this._restoreScroll();
        requestAnimationFrame(() => this._measureItemHeight());
    },

    // ─── Memoria del scroll ───
    //
    // Cada categoria recuerda por donde iba, y se guarda en el cliente para que
    // aguante entre sesiones. Es lo que hace usable una lista de 600 objetos:
    // sin esto, salir al juego y volver a abrir el menu te devolvia al principio.

    /** Guarda la posicion actual. Agrupado, que scroll dispara muchisimo. */
    _rememberScroll() {
        // Con una busqueda activa la lista es otra: su scroll no dice nada de
        // la categoria y guardarlo pisaria el bueno.
        if (Store.searchTerm) return;

        const cat = Store.currentCategory;
        if (!cat) return;

        this._scrollByCategory[cat] = this._scrollEl.scrollTop;

        clearTimeout(this._scrollSaveTimer);
        this._scrollSaveTimer = setTimeout(() => {
            Store.saveScrollPositions(this._scrollByCategory);
        }, 400);
    },

    /** Devuelve el scroll a donde estaba en esta categoria. */
    _restoreScroll() {
        const cat = Store.currentCategory;
        const pos = (!Store.searchTerm && cat) ? this._scrollByCategory[cat] : 0;

        clearTimeout(this._scrollRestoreTimer);
        if (!pos) return;

        // La altura de la rejilla acaba de cambiar y el navegador todavia no la
        // ha aplicado: si movemos el scroll ahora mismo lo recorta al rango
        // viejo y acabamos en 0. Se aplaza con setTimeout y no con
        // requestAnimationFrame, que no corre si la pagina no se esta pintando.
        this._scrollRestoreTimer = setTimeout(() => {
            SmoothScroll.jumpTo(pos);
            this._lastStart = -1;
            this._lastEnd = -1;
            this._onScroll();
        }, 0);
    },

    // ─── Geometria ───

    _measureColumns() {
        const width = this._gridEl.clientWidth || this._scrollEl.clientWidth;
        const gaps = this.COL_GAP * (this._cols - 1);
        this._colWidth = Math.max(40, (width - gaps) / this._cols);
    },

    _measureItemHeight() {
        const card = this._gridEl.querySelector('.emote-card');
        if (!card) return;
        const next = card.getBoundingClientRect().height + this.ROW_GAP;
        if (next > 10 && Math.abs(next - this._itemHeight) > 0.5) {
            this._itemHeight = next;
            this._lastStart = -1;
            this._lastEnd = -1;
            this._onScroll();
        }
    },

    _onScroll() {
        const items = Store.filteredItems;
        const total = items.length;

        if (total === 0) {
            this._showEmpty();
            return;
        }
        this._hideEmpty();

        if (this._colWidth <= 0) this._measureColumns();

        const totalRows = Math.ceil(total / this._cols);
        const scrollTop = this._scrollEl.scrollTop;
        const vpHeight = this._scrollEl.clientHeight;
        const firstRow = Math.floor(scrollTop / this._itemHeight);
        const visibleRows = Math.ceil(vpHeight / this._itemHeight);
        const startRow = Math.max(0, firstRow - this.BUFFER);
        const endRow = Math.min(totalRows, firstRow + visibleRows + this.BUFFER);
        const start = startRow * this._cols;
        const end = Math.min(total, endRow * this._cols);

        this._gridEl.style.height = Math.max(0, totalRows * this._itemHeight - this.ROW_GAP) + 'px';

        if (start === this._lastStart && end === this._lastEnd) return;
        this._lastStart = start;
        this._lastEnd = end;
        this._previewSuppressedUntil = Date.now() + 300;
        this._cancelHover();
        this._hideTooltip();

        clearTimeout(this._postScrollTimer);
        this._postScrollTimer = setTimeout(() => this._recheckHover(), 320);

        for (const [index, card] of Array.from(this._rendered.entries())) {
            if (index < start || index >= end) this._recycle(index, card);
        }

        const frag = document.createDocumentFragment();
        for (let i = start; i < end; i++) {
            const existing = this._rendered.get(i);
            if (existing) {
                this._position(existing, i);
                continue;
            }
            const card = this._pool.pop() || document.createElement('div');
            this._buildCard(card, items[i], i);
            this._rendered.set(i, card);
            frag.appendChild(card);
        }
        if (frag.childNodes.length) this._gridEl.appendChild(frag);
    },

    _showEmpty() {
        this._clearRendered();
        this._lastStart = 0;
        this._lastEnd = 0;

        if (!this._emptyEl) {
            this._emptyEl = document.createElement('div');
            this._emptyEl.className = 'empty-state';
        }

        this._emptyEl.replaceChildren();
        const icon = Icons.el(Store.searchTerm ? 'search' : 'folderOpen', 'empty-icon');
        this._emptyEl.appendChild(icon);

        const text = document.createElement('p');
        if (Store.searchTerm) {
            text.textContent = `${Store.t('searchnoresult')} "${Store.searchTerm}"`;
        } else if (Store.isCustomList(Store.currentCategory)) {
            text.textContent = Store.t('emptylist');
        } else if (Store.currentCategory === Store.FAVORITES) {
            text.textContent = Store.t('emptyfavorites');
        } else if (Store.currentCategory === Store.RECENTS || Store.currentCategory === Store.MOST_USED) {
            text.textContent = Store.t('emptyusage');
        } else {
            text.textContent = Store.t('noitems');
        }
        this._emptyEl.appendChild(text);

        this._gridEl.style.height = Math.max(this._scrollEl.clientHeight, 1) + 'px';
        if (this._emptyEl.parentNode !== this._gridEl || this._gridEl.childNodes.length !== 1) {
            this._gridEl.replaceChildren(this._emptyEl);
        }
    },

    _hideEmpty() {
        if (this._emptyEl && this._emptyEl.parentNode === this._gridEl) this._emptyEl.remove();
    },

    // ─── Ciclo de vida de las tarjetas ───

    _clearRendered() {
        for (const [index, card] of Array.from(this._rendered.entries())) {
            this._recycle(index, card);
        }
    },

    _recycle(index, card) {
        if (!card) return;
        if (this._dropdown && card.contains(this._dropdown)) this._closeDropdown();
        this._teardown(card);
        card.remove();
        this._rendered.delete(index);
        if (this._pool.length < this.MAX_POOL) this._pool.push(card);
    },

    _teardown(card) {
        card.replaceChildren();
        card.onclick = null;
        card.oncontextmenu = null;
        card.onmousedown = null;
        card.onmouseenter = null;
        card.onmouseleave = null;
        card.className = 'emote-card';
        card.removeAttribute('data-index');
        card.removeAttribute('data-cmd');
        card.removeAttribute('title');
        card.style.cssText = '';
    },

    _position(card, index) {
        const row = Math.floor(index / this._cols);
        const col = index % this._cols;
        card.dataset.index = String(index);
        card.style.top = row * this._itemHeight + 'px';
        card.style.left = col * (this._colWidth + this.COL_GAP) + 'px';
        card.style.width = this._colWidth + 'px';
        card.classList.toggle('selected', index === this._selectedIndex);
    },

    _buildCard(card, item, index) {
        this._teardown(card);
        this._position(card, index);

        if (item.hasPermission === false) card.classList.add('disabled');
        if (item._isActive) card.classList.add('active');
        if (Store.isFavorite(item.name, item.emoteType)) card.classList.add('favorited');

        if (item._isKeybind) {
            this._buildKeybindCard(card, item, index);
            return;
        }

        card.appendChild(Icons.el(this._iconFor(item), 'card-icon'));

        const label = document.createElement('span');
        label.className = 'card-label';
        const text = item.label || item.name;
        if (item._ranges && item._ranges.length) {
            label.appendChild(Fuzzy.highlight(text, item._ranges));
        } else {
            label.textContent = text;
        }
        card.appendChild(label);

        if (item._badge) {
            const badge = document.createElement('span');
            badge.className = 'card-badge';
            badge.textContent = item._badge;
            card.appendChild(badge);
        }

        const hasVariants = item.propVariations && item.propVariations.length > 0;
        if (hasVariants) {
            const variant = document.createElement('span');
            variant.className = 'card-variant';
            variant.textContent = item.propVariations.length + 'v';
            card.appendChild(variant);
        }

        const cmd = this._commandFor(item);
        if (cmd) card.dataset.cmd = cmd;

        card.onclick = (e) => {
            if (item.hasPermission === false) return;
            if (hasVariants && !e.shiftKey) {
                this._showVariants(card, item);
                return;
            }
            if (!this._readyToActivate(item, index, e)) return;
            // El doble clic es una decision tomada: lanza y sale del menu.
            this._activate(item, e, { close: e.detail >= 2 });
        };

        card.oncontextmenu = (e) => {
            e.preventDefault();
            this._showContextMenu(e, item, card);
        };

        card.onmousedown = (e) => {
            if (e.button === 1) {
                e.preventDefault();
                if (Store.config.keybindingEnabled) App.showKeybindModal(item);
            }
        };

        card.onmouseenter = () => {
            this._showTooltip(card);
            this._startPreview(card, item);
        };

        card.onmouseleave = () => {
            this._hideTooltip();
            this._cancelHover();
        };
    },

    _buildKeybindCard(card, item, index) {
        card.classList.add('keybind-card');
        if (item._isEmpty) card.classList.add('empty-slot');

        const slot = document.createElement('span');
        slot.className = 'card-slot';
        slot.textContent = item._slot;
        card.appendChild(slot);

        const label = document.createElement('span');
        label.className = 'card-label';
        label.textContent = item._isEmpty ? Store.t('emptyslot') : item.label;
        card.appendChild(label);

        if (item.keyLabel) {
            const key = document.createElement('span');
            key.className = 'card-key';
            key.textContent = item.keyLabel;
            card.appendChild(key);
        }

        card.onclick = (e) => {
            if (item._isEmpty) return;
            if (!this._readyToActivate(item, index, e)) return;
            this._activate(item, e, { close: e.detail >= 2 });
        };
        card.oncontextmenu = (e) => {
            e.preventDefault();
            if (!item._isEmpty) NUI.clearKeybind(item._slot);
        };
    },

    _iconFor(item) {
        switch (item.emoteType) {
            case 'Dances':       return 'music';
            case 'AnimalEmotes': return 'paw';
            case 'PropEmotes':   return 'cube';
            case 'Shared':       return 'users';
            case 'Walks':        return 'walk';
            case 'Expressions':  return 'masks';
            case 'Emojis':       return 'smile';
            default:             return 'play';
        }
    },

    _commandFor(item) {
        if (item._isKeybind || item._isEmoji) return null;
        if (item._isWalk) return '/walk ' + item.name.toLowerCase();
        if (item._isExpression) return '/mood ' + item.name.toLowerCase();
        return '/e ' + item.name;
    },

    // ─── Acciones ───

    /**
     * Con "confirmar antes de reproducir" activo, el primer clic sobre una
     * tarjeta solo la selecciona; hace falta un segundo clic sobre esa misma
     * tarjeta, un doble clic o Enter para lanzarla. Asi no se dispara una
     * animacion al recorrer la lista con el raton.
     *
     * Quedan fuera dos cosas a proposito:
     *  - Las formas de caminar y los animos, que no son animaciones que se
     *    "lancen" sino ajustes que se prueban uno detras de otro; obligar a dos
     *    clics para cambiar de andar solo estorba, y cambiarlo sin querer no
     *    tiene consecuencias.
     *  - Los gestos que ya son deliberados: Shift+clic (colocar) y el doble
     *    clic, que lanzan a la primera.
     *
     * @returns {boolean} true si hay que activar el elemento ya
     */
    _readyToActivate(item, index, e) {
        if (!Store.settings.confirmPlay) return true;
        if (!e) return true;                                  // vino del teclado
        if (item._isWalk || item._isExpression) return true;
        if (e.shiftKey || e.detail >= 2) return true;
        if (this._selectedIndex === index) return true;       // ya estaba elegida

        this._setSelected(index);
        return false;
    },

    /** Mueve la seleccion visible a una tarjeta concreta. */
    _setSelected(index) {
        const prev = this._rendered.get(this._selectedIndex);
        if (prev) prev.classList.remove('selected');

        this._selectedIndex = index;

        const next = this._rendered.get(index);
        if (next) next.classList.add('selected');
    },

    /**
     * Lanza lo que sea el elemento: animacion, forma de caminar, animo o emoji.
     *
     * @param {object} item
     * @param {MouseEvent?} e evento que lo origino, o null si vino del teclado
     * @param {{close?: boolean}} [opts] `close` cierra el menu despues de
     *   lanzarlo, para los gestos que ya son una decision tomada (doble clic y
     *   "Reproducir" del menu contextual). Cerrar el menu no corta la
     *   animacion: en Lua solo se quita el foco y se retira el ped de vista
     *   previa.
     */
    _activate(item, e, opts) {
        this.stopPreview();

        // La colocacion se queda con el control de la interfaz por su cuenta,
        // asi que aqui no se cierra nada.
        if (e && e.shiftKey && Store.config.placementEnabled
            && !item._isWalk && !item._isExpression && !item._isEmoji) {
            NUI.placeEmote(item.name);
            return;
        }

        if (item._isWalk) {
            NUI.setWalkStyle(item.name);
            this._scheduleUsageRefresh();
        } else if (item._isExpression) {
            NUI.setExpression(item.name);
            this._scheduleUsageRefresh();
        } else if (item._isEmoji) {
            NUI.showEmoji(item.name);
        } else if (item.emoteType === 'Shared') {
            NUI.playSharedEmote(item.name);
        } else {
            NUI.playEmote(item.name, item.emoteType);
            this._scheduleUsageRefresh();
        }

        if (opts && opts.close) NUI.closeMenu();
    },

    /**
     * El menu no se cierra al reproducir, asi que "Recientes" y "Mas usados" se
     * quedarian obsoletos. Pedimos el historial una sola vez tras una rafaga de
     * pulsaciones en lugar de en cada una.
     */
    _scheduleUsageRefresh() {
        clearTimeout(this._usageTimer);
        this._usageTimer = setTimeout(() => NUI.refreshUsage(), 1200);
    },

    activateSelected() {
        const item = Store.filteredItems[this._selectedIndex];
        if (!item || item.hasPermission === false) return;
        if (item._isKeybind && item._isEmpty) return;
        this._activate(item, null);
    },

    /** Alterna el favorito del elemento seleccionado (tecla F). */
    toggleFavoriteSelected() {
        const item = Store.filteredItems[this._selectedIndex];
        if (!item || item._isKeybind) return;
        const id = item.emoteType + '_' + item.name;
        const isFav = Store.toggleFavorite(id, {
            name: item.name,
            label: item.label || item.name,
            emoteType: item.emoteType,
        });
        Toast.show(
            Store.t(isFav ? 'addedtofavorites' : 'removedfromfavorites').replace('%s', item.label || item.name),
            isFav ? 'success' : 'info'
        );
        const card = this._rendered.get(this._selectedIndex);
        if (card) card.classList.toggle('favorited', isFav);
        if (Store.currentCategory === Store.FAVORITES) {
            App.refreshCurrentView();
        }
    },

    // ─── Vista previa ───

    _startPreview(card, item) {
        this._cancelHover();

        const delay = Store.settings.previewDelay;
        if (!delay || delay <= 0) return;
        if (item._isWalk || item._isEmoji || item._isKeybind || item.hasPermission === false) return;
        if (!Store.isOpen || Date.now() < this._previewSuppressedUntil) return;

        const key = item.emoteType + ':' + item.name;
        if (this._activePreviewKey === key) return;

        const bar = document.createElement('div');
        bar.className = 'preview-progress';
        bar.style.animationDuration = delay + 'ms';
        card.appendChild(bar);
        this._progressBar = bar;

        this._hoverTimer = setTimeout(() => {
            this._hoverTimer = null;
            if (this._progressBar) {
                this._progressBar.remove();
                this._progressBar = null;
            }
            if (!Store.isOpen || Date.now() < this._previewSuppressedUntil) return;
            if (this._activePreviewKey === key) return;

            this._activePreviewKey = key;
            NUI.previewEmote(item.name, item.emoteType);
        }, delay);
    },

    _cancelHover() {
        if (this._hoverTimer) {
            clearTimeout(this._hoverTimer);
            this._hoverTimer = null;
        }
        if (this._progressBar) {
            this._progressBar.remove();
            this._progressBar = null;
        }
    },

    _recheckHover() {
        if (!Store.isOpen) return;
        const el = document.elementFromPoint(this._mouseX, this._mouseY);
        const card = el && el.closest ? el.closest('.emote-card') : null;
        if (card && card.onmouseenter) card.onmouseenter();
    },

    stopPreview() {
        this._cancelHover();
        if (!this._activePreviewKey) return;
        this._activePreviewKey = null;
        NUI.stopPreview();
    },

    // ─── Variantes de props ───

    _parseVariantName(raw) {
        if (!raw.includes('<')) return { color: null, text: raw };
        const doc = new DOMParser().parseFromString(raw, 'text/html');
        const font = doc.querySelector('font[color]');
        if (font) return { color: font.getAttribute('color'), text: font.textContent.trim() };
        return { color: null, text: doc.body.textContent.trim() || raw };
    },

    _showVariants(cardEl, item) {
        this._closeDropdown();
        this._hideTooltip();

        const dropdown = document.createElement('div');
        dropdown.className = 'variant-dropdown';
        this._dropdown = dropdown;

        const addOption = (text, color, value) => {
            const option = document.createElement('div');
            option.className = 'variant-option';
            option.textContent = text;
            if (color) option.style.color = color;
            option.dataset.value = value !== undefined ? value : '';
            dropdown.appendChild(option);
        };

        addOption(Store.t('defaultvariant'), null, '__default__');
        for (const variation of item.propVariations) {
            const { color, text } = this._parseVariantName(variation.Name || variation.name || '');
            const value = variation.Value !== undefined ? variation.Value : variation.value;
            addOption(text || `${Store.t('variant')} ${value}`, color, value);
        }

        dropdown.onmousedown = (e) => {
            e.stopPropagation();
            e.preventDefault();
            const option = e.target.closest('.variant-option');
            if (!option) return;

            const value = option.dataset.value;
            this._closeDropdown();
            this.stopPreview();
            this._previewSuppressedUntil = Date.now() + 800;

            if (value === '__default__') {
                NUI.playEmote(item.name, item.emoteType);
            } else {
                NUI.playEmote(item.name, item.emoteType, Number(value));
            }
        };

        cardEl.appendChild(dropdown);

        setTimeout(() => {
            this._dropdownCloser = (e) => {
                if (dropdown.parentNode && !dropdown.contains(e.target)) this._closeDropdown();
            };
            document.addEventListener('mousedown', this._dropdownCloser, true);
        }, 0);
    },

    _closeDropdown() {
        if (this._dropdownCloser) {
            document.removeEventListener('mousedown', this._dropdownCloser, true);
            this._dropdownCloser = null;
        }
        if (this._dropdown) {
            this._dropdown.remove();
            this._dropdown = null;
        }
    },

    // ─── Navegacion con teclado ───

    _move(delta) {
        const total = Store.filteredItems.length;
        if (total === 0) return;
        if (this._selectedIndex < 0) {
            this._selectedIndex = delta > 0 ? 0 : total - 1;
        } else {
            this._selectedIndex = (this._selectedIndex + delta + total) % total;
        }
        this._scrollToSelected();
    },

    navigateUp()    { this._move(-this._cols); },
    navigateDown()  { this._move(this._cols); },
    navigateLeft()  { this._move(-1); },
    navigateRight() { this._move(1); },

    navigatePage(direction) {
        const total = Store.filteredItems.length;
        if (total === 0) return;
        const rows = Math.max(1, Math.floor(this._scrollEl.clientHeight / this._itemHeight) - 1);
        const next = this._selectedIndex + direction * rows * this._cols;
        this._selectedIndex = Math.min(total - 1, Math.max(0, next));
        this._scrollToSelected();
    },

    navigateEdge(toEnd) {
        const total = Store.filteredItems.length;
        if (total === 0) return;
        this._selectedIndex = toEnd ? total - 1 : 0;
        this._scrollToSelected();
    },

    _scrollToSelected() {
        this._lastStart = -1;
        this._lastEnd = -1;

        const row = Math.floor(this._selectedIndex / this._cols);
        const rowTop = row * this._itemHeight;
        const vpHeight = this._scrollEl.clientHeight;
        const scroll = this._scrollEl.scrollTop;

        if (rowTop < scroll) {
            SmoothScroll.scrollTo(rowTop);
        } else if (rowTop + this._itemHeight > scroll + vpHeight) {
            SmoothScroll.scrollTo(rowTop - vpHeight + this._itemHeight);
        }

        this._onScroll();
        this._cancelHover();

        const item = Store.filteredItems[this._selectedIndex];
        const delay = Store.settings.previewDelay;
        if (!delay || !item || item._isKeybind || item._isWalk || item._isEmoji || item.hasPermission === false) return;

        const key = item.emoteType + ':' + item.name;
        if (this._activePreviewKey === key) return;

        this._hoverTimer = setTimeout(() => {
            this._hoverTimer = null;
            if (!Store.isOpen || Date.now() < this._previewSuppressedUntil) return;
            this._activePreviewKey = key;
            NUI.previewEmote(item.name, item.emoteType);
        }, delay);
    },

    // ─── Tooltip del comando ───

    _showTooltip(card) {
        if (!Store.config.commandTooltipEnabled) return;
        const cmd = card.dataset.cmd;
        if (!cmd) { this._hideTooltip(); return; }

        this._tooltip.textContent = cmd;
        this._tooltip.classList.add('visible');

        const panel = document.getElementById('emote-menu').getBoundingClientRect();
        const rect = card.getBoundingClientRect();
        let x = rect.left + rect.width / 2 - panel.left;
        let y = rect.bottom - panel.top + 4;

        this._tooltip.style.left = x + 'px';
        this._tooltip.style.top = y + 'px';

        requestAnimationFrame(() => {
            if (!this._tooltip.classList.contains('visible')) return;
            const tw = this._tooltip.offsetWidth;
            const th = this._tooltip.offsetHeight;
            x = Math.max(tw / 2 + 4, Math.min(panel.width - tw / 2 - 4, x));
            if (y + th > panel.height - 4) y = rect.top - panel.top - th - 4;
            this._tooltip.style.left = x + 'px';
            this._tooltip.style.top = y + 'px';
        });
    },

    _hideTooltip() {
        if (this._tooltip) this._tooltip.classList.remove('visible');
    },

    // ─── Menu contextual ───

    _showContextMenu(e, item, card) {
        this._closeContextMenu();
        this._closeDropdown();
        this._hideTooltip();

        const menu = document.createElement('div');
        menu.className = 'ctx-menu';

        const emoteId = item.emoteType + '_' + item.name;
        const emoteData = { name: item.name, label: item.label || item.name, emoteType: item.emoteType };

        // Reproducir y salir. Va la primera por ser la accion principal.
        if (!item._isEmpty && item.hasPermission !== false) {
            const playEntry = this._ctxItem('play', Store.t('btn_play'));
            playEntry.onclick = () => {
                this._closeContextMenu();
                this._activate(item, null, { close: true });
            };
            menu.appendChild(playEntry);
            menu.appendChild(this._ctxDivider());
        }

        // Favorito
        const isFav = Store.isFavorite(item.name, item.emoteType);
        const favEntry = this._ctxItem(
            isFav ? 'star' : 'starOutline',
            isFav ? Store.t('btn_remove_favorite') : Store.t('btn_set_favorite'),
            isFav ? 'var(--accent)' : null
        );
        favEntry.onclick = () => {
            const nowFav = Store.toggleFavorite(emoteId, emoteData);
            card.classList.toggle('favorited', nowFav);
            Toast.show(
                Store.t(nowFav ? 'addedtofavorites' : 'removedfromfavorites').replace('%s', emoteData.label),
                nowFav ? 'success' : 'info'
            );
            if (Store.currentCategory === Store.FAVORITES) App.refreshCurrentView();
            this._closeContextMenu();
        };
        menu.appendChild(favEntry);

        // Colocar en el mundo
        const placeable = Store.config.placementEnabled
            && !item._isWalk && !item._isExpression && !item._isEmoji && !item._isKeybind;
        if (placeable) {
            const placeEntry = this._ctxItem('pin', Store.t('btn_place'));
            placeEntry.onclick = () => {
                this._closeContextMenu();
                this.stopPreview();
                NUI.placeEmote(item.name);
            };
            menu.appendChild(placeEntry);
        }

        // Emote de grupo
        const groupable = !item._isWalk && !item._isExpression && !item._isEmoji && !item._isKeybind
            && item.emoteType !== 'Shared';
        if (groupable) {
            const groupEntry = this._ctxItem('users', Store.t('btn_groupselect'));
            groupEntry.onclick = () => {
                this._closeContextMenu();
                this.stopPreview();
                NUI.groupEmote(item.name);
            };
            menu.appendChild(groupEntry);
        }

        // Asignar a una tecla
        if (Store.config.keybindingEnabled && !item._isKeybind) {
            const bindEntry = this._ctxItem('keyboard', Store.t('btn_setkeybind'));
            bindEntry.onclick = () => {
                this._closeContextMenu();
                App.showKeybindModal(item);
            };
            menu.appendChild(bindEntry);
        }

        // Copiar comando
        const cmd = this._commandFor(item);
        if (cmd) {
            const copyEntry = this._ctxItem('copy', Store.t('copycommand'));
            copyEntry.onclick = () => {
                this.copyText(cmd);
                Toast.show(Store.t('copiedcommand') + ': ' + cmd, 'success');
                this._closeContextMenu();
            };
            menu.appendChild(copyEntry);
        }

        // Listas personalizadas
        const listIds = Object.keys(Store.customLists);
        if (listIds.length > 0) {
            menu.appendChild(this._ctxDivider());
            for (const listId of listIds) {
                const list = Store.customLists[listId];
                const inList = Store.isInCustomList(listId, item.name, item.emoteType);
                const entry = this._ctxItem('folder', list.name, list.color, inList);
                entry.onclick = () => {
                    const nowIn = Store.toggleCustomListItem(listId, emoteId, emoteData);
                    const key = nowIn ? 'addedtolist' : 'removedfromlist';
                    Toast.show(
                        Store.t(key).replace('%s', emoteData.label).replace('%l', list.name),
                        nowIn ? 'success' : 'info'
                    );
                    if (Store.currentCategory === listId) App.refreshCurrentView();
                    this._closeContextMenu();
                };
                menu.appendChild(entry);
            }
        }

        menu.appendChild(this._ctxDivider());
        const newList = this._ctxItem('plus', Store.t('newlist'));
        newList.onclick = () => {
            this._closeContextMenu();
            App.showListModal(null, item);
        };
        menu.appendChild(newList);

        const panelEl = document.getElementById('emote-menu');
        panelEl.appendChild(menu);

        const panel = panelEl.getBoundingClientRect();
        let x = e.clientX - panel.left;
        let y = e.clientY - panel.top;
        menu.style.left = x + 'px';
        menu.style.top = y + 'px';

        requestAnimationFrame(() => {
            const w = menu.offsetWidth;
            const h = menu.offsetHeight;
            if (x + w > panel.width - 4) x = panel.width - w - 4;
            if (y + h > panel.height - 4) y = panel.height - h - 4;
            menu.style.left = Math.max(4, x) + 'px';
            menu.style.top = Math.max(4, y) + 'px';
        });

        this._ctxMenu = menu;
        setTimeout(() => {
            this._ctxCloser = (ev) => {
                if (!menu.contains(ev.target)) this._closeContextMenu();
            };
            document.addEventListener('mousedown', this._ctxCloser, true);
        }, 0);
    },

    _closeContextMenu() {
        if (this._ctxCloser) {
            document.removeEventListener('mousedown', this._ctxCloser, true);
            this._ctxCloser = null;
        }
        if (this._ctxMenu) {
            this._ctxMenu.remove();
            this._ctxMenu = null;
        }
    },

    _ctxItem(iconName, label, iconColor, checked) {
        const entry = document.createElement('div');
        entry.className = 'ctx-item';

        const icon = Icons.el(iconName, 'ctx-icon');
        if (iconColor) icon.style.color = iconColor;
        entry.appendChild(icon);

        const text = document.createElement('span');
        text.className = 'ctx-label';
        text.textContent = label;
        entry.appendChild(text);

        if (checked) entry.appendChild(Icons.el('check', 'ctx-check'));
        return entry;
    },

    _ctxDivider() {
        const div = document.createElement('div');
        div.className = 'ctx-divider';
        return div;
    },

    /** El portapapeles de la NUI no siempre esta disponible: dejamos un plan B. */
    /**
     * Copia al portapapeles.
     *
     * Se intenta primero con execCommand aunque este obsoleto: el CEF de FiveM
     * bloquea la Clipboard API por permissions policy, y aunque la promesa se
     * rechaza y caiamos igual al plan B, el navegador escupia un aviso en la
     * consola en cada copia. Asi no hay ruido.
     */
    copyText(text) {
        if (this._copyWithTextarea(text)) return;
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(text).catch(() => {});
        }
    },

    /** @returns {boolean} si la copia salio bien */
    _copyWithTextarea(text) {
        const ta = document.createElement('textarea');
        ta.value = text;
        ta.style.cssText = 'position:fixed;opacity:0;pointer-events:none';
        document.body.appendChild(ta);
        ta.select();

        let ok = false;
        try { ok = document.execCommand('copy'); } catch { ok = false; }

        ta.remove();
        return ok;
    }
};
