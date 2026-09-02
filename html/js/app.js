/**
 * dwkemotes - Orquestador de la interfaz
 * -----------------------------------------------------------------------------
 * Recibe los mensajes de Lua, construye el marco del menu (barra lateral,
 * cabecera, estado, pie) y reparte el trabajo entre Store, Grid y Settings.
 */

const TOAST_ICONS = {
    success: 'circleCheck',
    error: 'circleX',
    warning: 'warning',
    info: 'circleInfo',
};

const Toast = {
    MAX: 4,
    DEFAULT_MS: 3500,
    _el: null,

    init() {
        this._el = document.getElementById('toast-container');
    },

    show(msg, type = 'info', ms) {
        if (!this._el || !msg) return;
        if (!TOAST_ICONS[type]) type = 'info';
        const duration = Number(ms) > 0 ? Number(ms) : this.DEFAULT_MS;

        while (this._el.children.length >= this.MAX) {
            this._drop(this._el.lastElementChild);
        }

        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.setAttribute('role', 'status');

        toast.appendChild(Icons.el(TOAST_ICONS[type], 'toast-icon'));

        const span = document.createElement('span');
        span.className = 'toast-msg';
        this._richText(span, msg);
        toast.appendChild(span);

        const bar = document.createElement('div');
        bar.className = 'toast-bar';
        bar.style.animationDuration = duration + 'ms';
        toast.appendChild(bar);

        toast.addEventListener('click', () => this._drop(toast));
        toast._timer = setTimeout(() => this._drop(toast), duration);

        this._el.prepend(toast);
    },

    /**
     * Vuelca un mensaje de Lua respetando los codigos de color de GTA.
     *
     * Los avisos del recurso vienen con `~r~`, `~g~`, `~y~`, `~b~`, `~h~` y los
     * de vuelta a normal `~w~`/`~s~`, porque estaban escritos para el feed
     * nativo del juego. Aqui se traducen a `<span class="rt-*">` en vez de
     * mostrarse como texto suelto. Se construye con textContent, nunca con
     * innerHTML: el mensaje puede llevar el nombre de otro jugador.
     */
    _richText(host, msg) {
        const KNOWN = { r: 'rt-r', g: 'rt-g', y: 'rt-y', b: 'rt-b', h: 'rt-h' };
        let cls = null;

        for (const chunk of String(msg).split(/(~[a-z]~)/i)) {
            if (!chunk) continue;

            const code = /^~([a-z])~$/i.exec(chunk);
            if (code) {
                const letter = code[1].toLowerCase();
                // ~w~ y ~s~ vuelven al color normal; el resto abre un tramo.
                cls = KNOWN[letter] || null;
                continue;
            }

            if (cls) {
                const span = document.createElement('span');
                span.className = cls;
                span.textContent = chunk;
                host.appendChild(span);
            } else {
                host.appendChild(document.createTextNode(chunk));
            }
        }
    },

    _drop(el) {
        if (!el || !el.parentNode) return;
        clearTimeout(el._timer);
        if (el.classList.contains('toast-leaving')) {
            el.remove();
            return;
        }
        el.classList.add('toast-leaving');
        el.addEventListener('animationend', () => el.remove(), { once: true });
        // Si las animaciones estan desactivadas no llega animationend.
        setTimeout(() => el.remove(), 400);
    },

    clear() {
        if (!this._el) return;
        for (const el of Array.from(this._el.children)) el.remove();
    }
};

const App = {
    _menuEl: null,
    _sidebarEl: null,
    _footerEl: null,
    _titleEl: null,
    _statusEl: null,
    _hintEl: null,
    _marqueeTimer: null,
    _drag: { active: false, startX: 0, startY: 0, startLeft: 0, startTop: 0 },

    init() {
        this._checkDesignSystem();
        Icons.mount();
        Store.bootstrap();

        this._menuEl = document.getElementById('emote-menu');
        this._sidebarEl = document.getElementById('sidebar');
        this._footerEl = document.getElementById('menu-footer');
        this._titleEl = document.getElementById('category-title');
        this._statusEl = document.getElementById('status-bar');
        this._hintEl = document.getElementById('hint-overlay');

        Toast.init();
        Grid.init();
        Search.init();
        Settings.init();

        this._mountStaticIcons();
        this.applySettings();

        window.addEventListener('message', (e) => this._onMessage(e));
        window.addEventListener('resize', () => this._syncFooterMarquee());
        document.addEventListener('keydown', (e) => this._onKeyDown(e));
        document.addEventListener('contextmenu', (e) => e.preventDefault());

        document.getElementById('close-btn').addEventListener('click', () => NUI.closeMenu());
        document.getElementById('walklock-btn')
            .addEventListener('click', () => NUI.setWalkLock(!Store.walkLock));
        document.getElementById('keybind-cancel').addEventListener('click', () => this.hideKeybindModal());

        this._initDrag();
    },

    /**
     * Nombre accesible + tooltip de un boton que solo lleva icono.
     *
     * Se queda en el `title` nativo a proposito: el `data-rrp-tip` del sistema
     * pinta el globo con ::after dentro del elemento, y `#emote-menu` recorta
     * con `overflow: hidden` para redondear las esquinas — el globo de los
     * botones del borde derecho saldria cortado por la mitad.
     */
    _tipFor(id, label) {
        const el = document.getElementById(id);
        if (!el) return;
        el.setAttribute('aria-label', label);
        el.title = label;
    },

    _mountStaticIcons() {
        const put = (id, name, cls) => {
            const host = document.getElementById(id);
            if (host) host.replaceChildren(Icons.el(name, cls));
        };
        put('search-icon-slot', 'search', 'search-icon');
        put('walklock-btn', 'walk', 'header-icon');
        put('settings-btn', 'sliders', 'header-icon');
        put('close-btn', 'close', 'header-icon');
        put('settings-close', 'close', 'header-icon');
        put('list-modal-icon', 'folder', 'list-modal-glyph');
        put('list-confirm-icon', 'trash', 'list-confirm-glyph');
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Mensajes desde Lua
    // ─────────────────────────────────────────────────────────────────────────

    _onMessage(event) {
        const d = event.data;
        if (!d || !d.action) return;

        switch (d.action) {
            case 'openMenu':
                this._openMenu(d);
                break;
            case 'closeMenu':
                this._closeMenu();
                break;
            case 'showToast':
                Toast.show(d.msg, d.toastType, d.duration);
                break;
            case 'showHints':
                this._showHints(d.rows, d.warning);
                break;
            case 'hideHints':
                this._hideHints();
                break;
            case 'updateKeybinds':
                Store.updateKeybinds(d.keybinds);
                this.refreshCurrentView();
                break;
            case 'updateUsage':
                Store.updateDynamic(d);
                this.applySettings({ sidebar: true, order: true });
                break;
            case 'updateStatus':
                Store.activeWalk = d.activeWalk || '';
                Store.activeWalkLabel = d.activeWalkLabel || '';
                Store.activeExpression = d.activeExpression || '';
                Store.activeExpressionLabel = d.activeExpressionLabel || '';
                Store.walkLock = !!d.walkLock;
                Store.walkLockAvailable = !!d.walkLockAvailable;
                this._updateStatusBar();
                this._syncWalkLockButton();
                Settings.syncWalkLock();
                if (Store.currentCategory === Store.WALKS || Store.currentCategory === Store.EXPRESSIONS) {
                    this.refreshCurrentView();
                }
                break;
            case 'navigate':
                this._handleNavigate(d.direction);
                break;
        }
    },

    _openMenu(data) {
        Store.init(data);

        const input = document.getElementById('search-input');
        if (input) {
            input.placeholder = Store.t('searchemotes');
            input.value = '';
        }
        document.getElementById('search-clear').classList.add('hidden');
        // Iconos sin etiqueta: tooltip del sistema, no el nativo del navegador.
        this._tipFor('settings-btn', Store.t('settings'));
        this._tipFor('close-btn', Store.t('btn_back'));

        this._buildSidebar();
        this._buildFooter();
        this._updateCategoryTitle();
        this._updateStatusBar();
        this._syncWalkLockButton();
        this.applySettings();

        this._applyPanelPosition();
        this._menuEl.classList.remove('hidden');
        Store.isOpen = true;
        Grid.render();
    },

    _closeMenu() {
        this._menuEl.classList.add('hidden');
        Store.isOpen = false;
        Search.clear();
        Settings.close();
        Grid.stopPreview();
        SmoothScroll.stop();
        // Los avisos NO se limpian aqui: ahora viven en la capa de arriba a la
        // izquierda, fuera del menu, y tienen que seguir viendose al cerrarlo.
        // Se van solos cuando expiran.
    },

    refreshCurrentView() {
        this._updateCategoryTitle();
        Grid.render();
    },

    /**
     * Avisa si `design-system/tokens.css` no llego a cargarse.
     *
     * Sin el, todo lo que apunta a un token (`var(--rrp-*)`) queda sin valor:
     * las tarjetas y los botones se vuelven transparentes, los radios se van a
     * cero y la tipografia cae al serif del navegador. El menu "funciona",
     * asi que sin este aviso el sintoma es dificil de leer. La causa habitual
     * es haber tocado `files{}` del fxmanifest sin reiniciar el recurso.
     */
    _checkDesignSystem() {
        const token = getComputedStyle(document.documentElement)
            .getPropertyValue('--rrp-accent').trim();
        if (token) return;
        console.error(
            '[dwkemotes] No se ha cargado design-system/tokens.css. La interfaz se vera ' +
            'sin fondos, sin radios y con la tipografia equivocada. Comprueba que ' +
            "'html/design-system/*.css' esta en files{} del fxmanifest y reinicia el recurso."
        );
    },

    /**
     * Aplica los ajustes del jugador a la interfaz.
     * @param {{sidebar?: boolean, order?: boolean, relayout?: boolean}} [opts]
     */
    applySettings(opts = {}) {
        const s = Store.settings;
        const root = document.documentElement;

        root.style.setProperty('--accent', s.accent);
        root.style.setProperty('--accent-dim', this._alpha(s.accent, 0.16));
        root.style.setProperty('--accent-subtle', this._alpha(s.accent, 0.07));
        root.style.setProperty('--accent-border', this._alpha(s.accent, 0.42));
        root.style.setProperty('--panel-scale', s.scale / 100);
        root.style.setProperty('--panel-alpha', s.opacity / 100);
        root.style.setProperty('--cols', String(s.columns));

        document.body.classList.toggle('compact', !!s.compact);
        document.body.classList.toggle('no-anim', !s.animations);

        if (opts.order) {
            Store.rebuildCategoryOrder();
            if (!Store.categoryOrder.includes(Store.currentCategory)) {
                Store.setCategory(Store.categoryOrder[0]);
            }
        }
        if (opts.sidebar) {
            this._buildSidebar();
            this._updateCategoryTitle();
        }
        if (opts.relayout || opts.order) {
            requestAnimationFrame(() => Grid.relayout());
        }
        if (opts.order) {
            this.refreshCurrentView();
        }

        // El pie depende de los ajustes (atajo de Enter) y su ancho util depende
        // de la escala, las columnas y el modo compacto.
        if (this._footerEl && this._footerEl.firstElementChild) this._buildFooter();
        else this._syncFooterMarquee();
    },

    /** #RRGGBB -> rgba() con la opacidad pedida. */
    _alpha(hex, alpha) {
        const m = /^#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$/i.exec(String(hex));
        if (!m) return `rgba(206, 220, 0, ${alpha})`;   // --rrp-accent
        const [r, g, b] = [m[1], m[2], m[3]].map(v => parseInt(v, 16));
        return `rgba(${r}, ${g}, ${b}, ${alpha})`;
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Barra lateral
    // ─────────────────────────────────────────────────────────────────────────

    _buildSidebar() {
        this._sidebarEl.replaceChildren();
        this._sidebarEl.classList.toggle('with-labels', !!Store.settings.showLabels);

        let lastCustomIdx = -1;

        Store.categoryOrder.forEach((cat, i) => {
            const item = document.createElement('button');
            item.type = 'button';
            item.className = 'sidebar-item';
            if (cat === Store.currentCategory) item.classList.add('active');
            item.dataset.category = cat;

            // Sin etiqueta debajo, el icono solo no dice que categoria es, asi
            // que siempre lleva nombre accesible y tooltip.
            //
            // Aqui NO se usa `data-rrp-tip` del sistema: lo dibuja con ::after
            // dentro del propio elemento, y la barra lateral es un contenedor
            // con `overflow-x: hidden` (y el panel entero con `overflow:
            // hidden`, por las esquinas redondeadas), asi que el globo se
            // recortaria contra el borde. El title nativo no se recorta.
            const label = Store.getCategoryLabel(cat);
            item.setAttribute('aria-label', label);
            item.title = label;

            // El color va como variable y no en linea: asi la regla del estado
            // activo (icono en acento) puede ganarle sin pelear con un style="".
            const icon = Icons.el(Store.getCategoryIcon(cat), 'sidebar-icon');
            item.style.setProperty('--cat-color', Store.getCategoryColor(cat));
            item.appendChild(icon);

            if (Store.settings.showLabels) {
                const labelEl = document.createElement('span');
                labelEl.className = 'sidebar-label';
                labelEl.textContent = this._shortLabel(cat);
                item.appendChild(labelEl);
            }

            item.onclick = () => this.selectCategory(cat);

            if (Store.isCustomList(cat)) {
                lastCustomIdx = i;
                item.oncontextmenu = (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    this.showListModal(cat);
                };
            }

            this._sidebarEl.appendChild(item);
        });

        // Boton "+" justo despues de las listas del jugador
        const addItem = document.createElement('button');
        addItem.type = 'button';
        addItem.className = 'sidebar-item sidebar-add';
        addItem.title = Store.t('newlist');
        addItem.appendChild(Icons.el('plus', 'sidebar-icon'));
        addItem.onclick = () => this.showListModal();

        const insertAt = lastCustomIdx >= 0 ? lastCustomIdx + 1 : this._firstNonPinnedIndex();
        const ref = this._sidebarEl.children[insertAt];
        ref ? this._sidebarEl.insertBefore(addItem, ref) : this._sidebarEl.appendChild(addItem);
    },

    /** Indice justo despues de favoritos / recientes / mas usados. */
    _firstNonPinnedIndex() {
        const pinned = new Set([Store.FAVORITES, Store.RECENTS, Store.MOST_USED]);
        let i = 0;
        while (i < Store.categoryOrder.length && pinned.has(Store.categoryOrder[i])) i++;
        return i;
    },

    /**
     * Nombre para la barra lateral. Solo quitamos los emojis decorativos que las
     * categorias traen a un lado o al otro ("🕺 Bailes", "Animaciones 🎬"); del
     * ancho se encarga el CSS, que corta con puntos suspensivos en dos lineas.
     * Recortar aqui por numero de caracteres dejaba nombres ambiguos como
     * "Animaci" para dos categorias distintas.
     */
    _shortLabel(cat) {
        const full = Store.getCategoryLabel(cat);
        const clean = full
            .replace(/^[\p{Emoji}\p{Emoji_Component}\s]+/u, '')
            .replace(/[\p{Emoji}\p{Emoji_Component}\s]+$/u, '')
            .trim();
        return clean || full;
    },

    selectCategory(cat) {
        Search.clear();
        Store.setCategory(cat);
        this._setActiveCategory(cat);
        this._updateCategoryTitle();
        Grid.stopPreview();
        Grid.render();
    },

    _setActiveCategory(cat) {
        this._sidebarEl.querySelectorAll('.sidebar-item').forEach(el => {
            el.classList.toggle('active', el.dataset.category === cat);
        });
    },

    updateSidebar() {
        if (Store.searchTerm) {
            this._sidebarEl.querySelectorAll('.sidebar-item').forEach(el => el.classList.remove('active'));
        } else {
            this._setActiveCategory(Store.currentCategory);
        }
        this._updateCategoryTitle();
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Cabecera y estado
    // ─────────────────────────────────────────────────────────────────────────

    _updateCategoryTitle() {
        if (!this._titleEl) return;
        this._titleEl.replaceChildren();

        if (Store.searchTerm) {
            const count = Store.filteredItems.length;
            this._titleEl.textContent = `${count} ${Store.t('searchmenudesc')} "${Store.searchTerm}"`;
            return;
        }

        const cat = Store.currentCategory;

        // Mismo icono del sprite que en la barra lateral, en vez del emoji que
        // viene dentro de la etiqueta traducida: los emojis los pinta la fuente
        // del sistema y no siguen ni el color ni el trazo del resto del menu.
        const icon = Icons.el(Store.getCategoryIcon(cat), 'cat-icon');
        icon.style.setProperty('--cat-color', Store.getCategoryColor(cat));
        this._titleEl.appendChild(icon);

        // `_shortLabel` quita el emoji del principio y del final de la etiqueta.
        this._titleEl.appendChild(document.createTextNode(this._shortLabel(cat)));

        const count = Store.getCategoryCount(cat);
        if (count > 0) {
            const span = document.createElement('span');
            span.className = 'cat-count';
            span.textContent = String(count);
            this._titleEl.appendChild(span);
        }

        const addAction = (label, onClick) => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'title-action';
            btn.textContent = label;
            btn.onclick = onClick;
            this._titleEl.appendChild(btn);
        };

        if (Store.isCustomList(cat)) {
            addAction(Store.t('editlist'), () => this.showListModal(cat));
        } else if (cat === Store.WALKS) {
            addAction(Store.t('normalreset'), () => NUI.resetWalkStyle());
        } else if (cat === Store.EXPRESSIONS) {
            addAction(Store.t('normalreset'), () => NUI.resetExpression());
        } else if (cat === Store.RECENTS || cat === Store.MOST_USED) {
            addAction(Store.t('clearusage'), () => Settings.clearUsage());
        }
    },

    _buildFooter() {
        this._footerEl.replaceChildren();

        // Los atajos van dentro de una pista propia para poder desplazarla
        // cuando no caben: ver _syncFooterMarquee.
        const track = document.createElement('div');
        track.className = 'footer-track';

        // Solo lo que no es evidente por la propia interfaz: el resto vive en el
        // menu contextual y en los tooltips.
        const hints = [
            ['Tab', Store.t('hint_category')],
            ['F', Store.t('hint_favorite')],
            ['Supr', Store.t('hint_cancel')],
        ];
        // Con la confirmacion activa, el clic solo elige: hay que decir con que
        // se lanza.
        if (Store.settings.confirmPlay) hints.splice(0, 0, ['Enter', Store.t('hint_play')]);
        if (Store.config.placementEnabled) hints.push(['Shift', Store.t('hint_place')]);

        for (const [key, label] of hints) {
            const chunk = document.createElement('span');
            chunk.className = 'footer-hint';

            const kbd = document.createElement('kbd');
            kbd.textContent = key;
            chunk.appendChild(kbd);

            const text = document.createElement('span');
            text.textContent = label;
            chunk.appendChild(text);

            track.appendChild(chunk);
        }

        this._footerEl.appendChild(track);
        this._syncFooterMarquee();
    },

    /** Velocidad del desplazamiento del pie, en px por segundo. */
    _FOOTER_SPEED: 42,

    /**
     * Decide si los atajos del pie tienen que desplazarse solos.
     *
     * No siempre caben: el ancho depende del panel, de la escala de la interfaz
     * y de lo largas que sean las palabras del idioma. Cuando sobra ancho, la
     * pista se anima de una punta a la otra; la velocidad es constante, asi que
     * la duracion sale de cuanto sobra y un pie muy lleno no se lee mas deprisa
     * que uno que casi cabe.
     *
     * Con las animaciones desactivadas desde los ajustes del menu no se anima
     * nada: `body.no-anim` recorta cualquier animacion a 0.001ms y dejaria la
     * pista clavada en el extremo. En ese caso el pie se vuelve desplazable
     * con la rueda.
     *
     * Aqui NO se mira `prefers-reduced-motion`. Windows la activa en cuanto se
     * desactivan las animaciones del sistema, algo que mucha gente hace por
     * rendimiento, y el CEF de FiveM la hereda: el pie se quedaba cortado sin
     * forma de leerlo. Quien quiera pararlo tiene el interruptor del menu, que
     * es una decision explicita sobre esta interfaz. La hoja de estilos hace la
     * misma excepcion para `.footer-track.scrolling`.
     */
    _syncFooterMarquee() {
        const footer = this._footerEl;
        const track = footer && footer.firstElementChild;
        if (!track) return;

        // Medir sin la animacion puesta: si no, se mide la posicion desplazada.
        track.classList.remove('scrolling');
        footer.classList.remove('no-marquee');

        // La medida va en un temporizador y NO en requestAnimationFrame: rAF
        // solo corre si la pagina se esta pintando, y si no lo esta en ese
        // momento el callback no llega a ejecutarse nunca — el pie se quedaba
        // cortado y quieto para siempre. Un timeout se ejecuta igual.
        // Un unico temporizador compartido: _buildFooter puede encadenarse
        // varias veces al abrir el menu, y asi solo se mide la ultima pista en
        // lugar de una que ya se ha quedado fuera del arbol.
        clearTimeout(this._marqueeTimer);
        this._marqueeTimer = setTimeout(() => this._applyFooterMarquee(0), 0);
    },

    /**
     * Mide el pie y arranca (o no) el desplazamiento.
     * @param {number} attempt reintentos gastados; el menu puede estar todavia
     *   oculto (`display: none`) cuando llega la primera medida.
     */
    _applyFooterMarquee(attempt) {
        const footer = this._footerEl;
        const track = footer && footer.firstElementChild;
        if (!track || !track.isConnected) return;

        // Con el menu cerrado no hay nada que medir.
        if (!footer.clientWidth) {
            if (attempt < 5) {
                this._marqueeTimer = setTimeout(() => this._applyFooterMarquee(attempt + 1), 60);
            }
            return;
        }

        const style = getComputedStyle(footer);
        const available = footer.clientWidth
            - (parseFloat(style.paddingLeft) || 0)
            - (parseFloat(style.paddingRight) || 0);
        const overflow = Math.ceil(track.scrollWidth - available);
        if (overflow <= 1) return;

        if (!Store.settings.animations) {
            footer.classList.add('no-marquee');
            return;
        }

        // El recorrido ocupa el 68% del ciclo (16%-84% de los keyframes); el
        // resto son las pausas de cada extremo.
        const travel = overflow + 2;
        const duration = Math.max(3, travel / this._FOOTER_SPEED / 0.68);

        track.style.setProperty('--marquee-shift', travel + 'px');
        track.style.setProperty('--marquee-duration', duration.toFixed(2) + 's');
        track.classList.add('scrolling');
    },

    /**
     * Pinta el panel de atajos en pantalla.
     *
     * Es el sustituto del cuadro de ayuda nativo de GTA, que lo dibuja el motor
     * y no se puede llevar al sistema de diseno. Se muestra con el menu cerrado
     * (colocacion de animaciones), asi que no depende de #emote-menu.
     *
     * @param {{keys: string[], label: string}[]} rows
     * @param {string} [warning] linea de aviso que va encima, en rojo
     */
    _showHints(rows, warning) {
        if (!this._hintEl || !Array.isArray(rows) || !rows.length) return this._hideHints();

        const warnEl = document.getElementById('hint-warning');
        warnEl.textContent = warning || '';
        warnEl.classList.toggle('hidden', !warning);

        const list = document.getElementById('hint-rows');
        list.replaceChildren();

        for (const row of rows) {
            if (!row || !Array.isArray(row.keys)) continue;

            const line = document.createElement('div');
            line.className = 'hint-row';

            const keys = document.createElement('span');
            keys.className = 'hint-keys';
            row.keys.forEach((key, i) => {
                if (i > 0) {
                    const sep = document.createElement('span');
                    sep.className = 'hint-sep';
                    sep.textContent = '/';
                    keys.appendChild(sep);
                }
                const kbd = document.createElement('kbd');
                kbd.textContent = key;
                keys.appendChild(kbd);
            });
            line.appendChild(keys);

            const label = document.createElement('span');
            label.className = 'hint-label';
            label.textContent = row.label || '';
            line.appendChild(label);

            list.appendChild(line);
        }

        this._hintEl.classList.remove('hidden');
    },

    _hideHints() {
        if (this._hintEl) this._hintEl.classList.add('hidden');
    },

    /**
     * Pone el boton de "caminar con la animacion" de la cabecera al dia.
     *
     * Vive arriba y no solo en los ajustes porque es un modo que se enciende y
     * se apaga a menudo, y bajar a Ajustes cada vez para algo asi sobra. El
     * estado se ve en el propio boton (encendido = acento), asi que la barra de
     * estado ya no lo repite.
     */
    _syncWalkLockButton() {
        const btn = document.getElementById('walklock-btn');
        if (!btn) return;

        btn.classList.toggle('hidden', !Store.walkLockAvailable);
        btn.classList.toggle('active', !!Store.walkLock);
        btn.setAttribute('aria-checked', String(!!Store.walkLock));

        this._tipFor('walklock-btn', Store.t('walklock'));
    },

    _updateStatusBar() {
        if (!this._statusEl) return;
        this._statusEl.replaceChildren();

        const hasWalk = !!Store.activeWalk;
        const hasExpr = !!Store.activeExpression;
        // "Caminar con la animacion" ya no tiene ficha aqui: lo dice el boton de
        // la cabecera, que ademas esta siempre visible.
        if (!hasWalk && !hasExpr) {
            this._statusEl.classList.add('hidden');
            return;
        }
        this._statusEl.classList.remove('hidden');

        const card = document.createElement('div');
        card.className = 'status-card';

        if (hasWalk) {
            card.appendChild(this._statusItem('walk', 'var(--rrp-hover-btn-bg)',
                Store.activeWalkLabel || Store.activeWalk, () => NUI.resetWalkStyle()));
        }
        if (hasExpr) {
            card.appendChild(this._statusItem('masks', 'var(--rrp-hover-btn-bg)',
                Store.activeExpressionLabel || Store.activeExpression, () => NUI.resetExpression()));
        }

        this._statusEl.appendChild(card);
    },

    _statusItem(iconName, color, label, onReset) {
        const item = document.createElement('div');
        item.className = 'status-item';

        const icon = Icons.el(iconName, 'status-item-icon');
        icon.style.color = color;
        item.appendChild(icon);

        const text = document.createElement('span');
        text.className = 'status-item-label';
        text.textContent = label;
        item.appendChild(text);

        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'status-item-reset';
        btn.title = Store.t('normalreset');
        btn.appendChild(Icons.el('close'));
        btn.onclick = (e) => {
            e.stopPropagation();
            onReset();
        };
        item.appendChild(btn);

        return item;
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Teclado
    // ─────────────────────────────────────────────────────────────────────────

    _onKeyDown(e) {
        if (!Store.isOpen) return;
        if (Search.isFocused()) return;

        const inModal = !document.getElementById('list-modal').classList.contains('hidden')
            || !document.getElementById('keybind-modal').classList.contains('hidden');

        if (e.key === 'Escape') {
            if (inModal) {
                this.hideListModal();
                this.hideKeybindModal();
            } else if (Settings.isOpen()) {
                Settings.close();
            } else {
                NUI.closeMenu();
            }
            return;
        }

        if (inModal) return;

        // Ctrl+1..9 salta a la categoria n
        if ((e.ctrlKey || e.metaKey) && e.key >= '1' && e.key <= '9') {
            e.preventDefault();
            const cat = Store.categoryOrder[Number(e.key) - 1];
            if (cat) this.selectCategory(cat);
            return;
        }

        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'f') {
            e.preventDefault();
            Search.focus();
            return;
        }

        switch (e.key) {
            case 'ArrowUp':    e.preventDefault(); Grid.navigateUp(); break;
            case 'ArrowDown':  e.preventDefault(); Grid.navigateDown(); break;
            case 'ArrowLeft':  e.preventDefault(); Grid.navigateLeft(); break;
            case 'ArrowRight': e.preventDefault(); Grid.navigateRight(); break;
            case 'PageUp':     e.preventDefault(); Grid.navigatePage(-1); break;
            case 'PageDown':   e.preventDefault(); Grid.navigatePage(1); break;
            case 'Home':       e.preventDefault(); Grid.navigateEdge(false); break;
            case 'End':        e.preventDefault(); Grid.navigateEdge(true); break;
            case 'Enter':      e.preventDefault(); Grid.activateSelected(); break;
            case 'Tab':
                e.preventDefault();
                {
                    const next = Store.cycleCategory(e.shiftKey ? -1 : 1);
                    if (next) this.selectCategory(next);
                }
                break;
            case '/':
                e.preventDefault();
                Search.focus();
                break;
            case 'f':
            case 'F':
                e.preventDefault();
                Grid.toggleFavoriteSelected();
                break;
            case 'Delete':
                e.preventDefault();
                NUI.cancelEmote();
                break;
        }
    },

    _handleNavigate(direction) {
        switch (direction) {
            case 'up':     Grid.navigateUp(); break;
            case 'down':   Grid.navigateDown(); break;
            case 'left':   Grid.navigateLeft(); break;
            case 'right':  Grid.navigateRight(); break;
            case 'select': Grid.activateSelected(); break;
            case 'back':   NUI.closeMenu(); break;
        }
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Modal de keybinds
    // ─────────────────────────────────────────────────────────────────────────

    showKeybindModal(item) {
        const modal = document.getElementById('keybind-modal');
        const title = document.getElementById('keybind-modal-title');
        const slots = document.getElementById('keybind-slots');
        const cancel = document.getElementById('keybind-cancel');

        title.textContent = `${Store.t('btn_setkeybind')}: ${item.label || item.name}`;
        cancel.textContent = Store.t('btn_back');
        slots.replaceChildren();

        for (const kb of Store.keybinds) {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'keybind-slot-btn';

            const key = document.createElement('kbd');
            key.textContent = kb.keyLabel || '—';
            btn.appendChild(key);

            const label = document.createElement('span');
            label.textContent = kb.emoteName ? kb.label : Store.t('emptyslot');
            if (!kb.emoteName) label.classList.add('muted');
            btn.appendChild(label);

            btn.onclick = () => {
                NUI.assignKeybind(kb.slot, item.name, item.emoteType, item.label || item.name);
                this.hideKeybindModal();
            };
            slots.appendChild(btn);
        }

        modal.classList.remove('hidden');
    },

    hideKeybindModal() {
        document.getElementById('keybind-modal').classList.add('hidden');
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Modal de listas
    // ─────────────────────────────────────────────────────────────────────────

    _listModalState: null,
    // EXCEPCION DELIBERADA AL SISTEMA DE DISENO
    // Estos son los colores que el jugador puede elegir para sus listas
    // personalizadas, y quedan guardados en su cliente junto con la lista. Son
    // datos suyos, no decoracion nuestra: cambiar la paleta dejaria huerfano el
    // color de las listas que ya tenga creadas. Si el sistema ResetRP acaba
    // definiendo una paleta categorica, hay que migrarlos con ella.
    _LIST_COLORS: ['#FF453A', '#FF9F0A', '#FFD60A', '#30D158', '#64D2FF', '#0A84FF', '#5E5CE6', '#FF375F'],

    showListModal(listId, autoAddItem) {
        const isEdit = !!listId;
        const list = isEdit ? Store.customLists[listId] : null;

        if (!isEdit && Object.keys(Store.customLists).length >= Store.MAX_CUSTOM_LISTS) {
            Toast.show(Store.t('maxlists'), 'warning');
            return;
        }

        const modal = document.getElementById('list-modal');
        const title = document.getElementById('list-modal-title');
        const nameInput = document.getElementById('list-name-input');
        const colors = document.getElementById('list-color-picker');
        const saveBtn = document.getElementById('list-save-btn');
        const cancelBtn = document.getElementById('list-cancel-btn');
        const deleteBtn = document.getElementById('list-delete-btn');
        const iconEl = document.getElementById('list-modal-icon');

        title.textContent = isEdit ? Store.t('editlist') : Store.t('newlist');
        nameInput.value = isEdit ? list.name : '';
        nameInput.placeholder = Store.t('listname');

        let selectedColor = isEdit ? list.color : this._LIST_COLORS[0];
        const paintIcon = (c) => {
            iconEl.style.background = this._alpha(c, 0.12);
            iconEl.style.color = c;
        };
        paintIcon(selectedColor);

        colors.replaceChildren();
        for (const c of this._LIST_COLORS) {
            const dot = document.createElement('button');
            dot.type = 'button';
            dot.className = 'color-dot' + (c === selectedColor ? ' active' : '');
            dot.style.background = c;
            dot.onclick = () => {
                selectedColor = c;
                colors.querySelectorAll('.color-dot').forEach(d => d.classList.toggle('active', d === dot));
                paintIcon(c);
            };
            colors.appendChild(dot);
        }

        deleteBtn.classList.toggle('hidden', !isEdit);
        deleteBtn.textContent = Store.t('deletelist');
        saveBtn.textContent = isEdit ? Store.t('savelist') : Store.t('createlist');
        cancelBtn.textContent = Store.t('btn_back');

        this._listModalState = { listId, autoAddItem };

        saveBtn.onclick = () => {
            const name = nameInput.value.trim();
            if (!name) {
                nameInput.focus();
                return;
            }
            if (this._listModalState.listId) {
                Store.updateCustomList(this._listModalState.listId, name, selectedColor);
            } else {
                const id = Store.createCustomList(name, selectedColor);
                const it = this._listModalState.autoAddItem;
                if (it) {
                    Store.toggleCustomListItem(id, it.emoteType + '_' + it.name, {
                        name: it.name, label: it.label || it.name, emoteType: it.emoteType
                    });
                }
            }
            this.hideListModal();
            this._buildSidebar();
            this._updateCategoryTitle();
        };

        cancelBtn.onclick = () => this.hideListModal();
        deleteBtn.onclick = () => this._showDeleteConfirm(nameInput.value.trim() || list.name);

        nameInput.onfocus = () => NUI.searchFocus();
        nameInput.onblur = () => NUI.searchBlur();
        nameInput.onkeydown = (e) => {
            if (e.key === 'Enter') saveBtn.click();
        };

        modal.classList.remove('hidden');
        nameInput.focus();
    },

    hideListModal() {
        document.getElementById('list-modal').classList.add('hidden');
        document.getElementById('list-modal-form').classList.remove('hidden');
        document.getElementById('list-confirm-delete').classList.add('hidden');
        this._listModalState = null;
        NUI.searchBlur();
    },

    _showDeleteConfirm(listName) {
        const form = document.getElementById('list-modal-form');
        const confirm = document.getElementById('list-confirm-delete');

        document.getElementById('list-confirm-title').textContent = `${Store.t('deletelist')} "${listName}"?`;
        document.getElementById('list-confirm-msg').textContent = Store.t('cannotundo');

        const backBtn = document.getElementById('list-confirm-back');
        const yesBtn = document.getElementById('list-confirm-yes');
        backBtn.textContent = Store.t('btn_back');
        yesBtn.textContent = Store.t('confirmdelete');

        form.classList.add('hidden');
        confirm.classList.remove('hidden');

        backBtn.onclick = () => {
            confirm.classList.add('hidden');
            form.classList.remove('hidden');
        };

        yesBtn.onclick = () => {
            const id = this._listModalState && this._listModalState.listId;
            if (!id) return;
            Store.deleteCustomList(id);
            this.hideListModal();
            this._buildSidebar();
            this._setActiveCategory(Store.currentCategory);
            this.refreshCurrentView();
        };
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Arrastre del panel
    // ─────────────────────────────────────────────────────────────────────────

    _initDrag() {
        const handle = document.getElementById('drag-handle');
        if (!handle) return;

        handle.addEventListener('mousedown', (e) => {
            if (!Store.isOpen) return;
            e.preventDefault();
            const rect = this._menuEl.getBoundingClientRect();
            this._drag = {
                active: true,
                startX: e.clientX,
                startY: e.clientY,
                startLeft: rect.left,
                startTop: rect.top,
            };
            handle.classList.add('dragging');
        });

        handle.addEventListener('dblclick', () => {
            Store.setSetting('panelPos', null);
            this._applyPanelPosition();
        });

        document.addEventListener('mousemove', (e) => {
            if (!this._drag.active) return;
            const pos = this._clampPosition(
                this._drag.startLeft + (e.clientX - this._drag.startX),
                this._drag.startTop + (e.clientY - this._drag.startY)
            );
            this._placePanel(pos);
            this._pendingPos = pos;
        });

        document.addEventListener('mouseup', () => {
            if (!this._drag.active) return;
            this._drag.active = false;
            handle.classList.remove('dragging');
            if (this._pendingPos) {
                Store.setSetting('panelPos', this._pendingPos);
                this._pendingPos = null;
            }
        });
    },

    _clampPosition(left, top) {
        const menuW = this._menuEl.offsetWidth || 320;
        const menuH = this._menuEl.offsetHeight || 400;
        return {
            left: Math.max(-(menuW - 120), Math.min(window.innerWidth - 120, left)),
            top: Math.max(0, Math.min(window.innerHeight - Math.min(menuH, 120), top)),
        };
    },

    _placePanel(pos) {
        this._menuEl.style.left = pos.left + 'px';
        this._menuEl.style.top = pos.top + 'px';
        this._menuEl.style.right = 'auto';
        this._menuEl.classList.add('dragged');
    },

    _applyPanelPosition() {
        const saved = Store.settings.panelPos;
        if (saved && Number.isFinite(saved.left) && Number.isFinite(saved.top)) {
            const pos = this._clampPosition(saved.left, saved.top);
            Store.settings.panelPos = pos;
            this._placePanel(pos);
            return;
        }
        this._menuEl.style.left = '';
        this._menuEl.style.top = '';
        this._menuEl.style.right = '';
        this._menuEl.classList.remove('dragged');
    }
};

document.addEventListener('DOMContentLoaded', () => App.init());
