/**
 * dwkemotes - Estado del menu
 * -----------------------------------------------------------------------------
 * Fuente unica de verdad para la interfaz. Recibe el payload de Lua, mantiene
 * favoritos / listas / ajustes en el almacenamiento local del jugador y expone
 * la lista ya filtrada que dibuja la rejilla.
 */
const Store = {
    // ── Datos recibidos de Lua ──
    categories: {},
    keybinds: [],
    walks: [],
    expressions: [],
    emojis: [],
    recents: [],
    mostUsed: [],
    config: {},
    translations: {},
    activeWalk: '',
    activeWalkLabel: '',
    /** "Caminar con la animacion": lo lleva Lua, aqui solo se refleja. */
    walkLock: false,
    walkLockAvailable: false,
    activeExpression: '',
    activeExpressionLabel: '',

    // ── Estado local ──
    favorites: {},
    customLists: {},
    /** Las mantiene Lua (KVP); aqui solo viven en memoria para pintarlas. */
    playlists: [],
    settings: {},
    currentCategory: null,
    searchTerm: '',
    filteredItems: [],
    categoryOrder: [],
    isOpen: false,

    // ── Identificadores de categorias virtuales ──
    FAVORITES: '__favorites__',
    RECENTS: '__recents__',
    MOST_USED: '__mostused__',
    KEYBINDS: '__keybinds__',
    WALKS: '__walks__',
    EXPRESSIONS: '__expressions__',
    EMOJIS: '__emojis__',
    CUSTOM_PREFIX: '__custom_',
    MAX_CUSTOM_LISTS: 10,
    PLAYLISTS: '__playlists__',

    _LS: 'dwkemotes:',
    _LEGACY_LS: 'rpemotes:',
    _GTA_CODE_RE: /~[a-zA-Z]~/g,
    _labelMap: {},
    _variantMap: {},
    _searchIndex: [],

    // Version del formato de ajustes. Se sube cuando un valor por defecto
    // cambia por una decision de diseno y tiene que llegar tambien a quien ya
    // tiene los ajustes guardados. Ver _migrateSettings.
    SETTINGS_VERSION: 2,

    DEFAULT_SETTINGS: {
        // Fijo, ya no ajustable: es `--rrp-teal`, el color con el que el sistema
        // de diseno marca lo seleccionado y la accion principal. Sigue aqui
        // porque applySettings lo inyecta como `--accent` y sus derivados.
        accent: '#019685',
        v: 2,                // = SETTINGS_VERSION
        columns: 2,
        scale: 100,
        previewDelay: 500,
        animations: true,
        confirmPlay: true,
        // Cerrar el menu al lanzar una animacion. Desactivado por defecto: es el
        // comportamiento que tenia el menu antes de que esto fuese elegible.
        closeOnPlay: false,
        showRecents: true,
        showMostUsed: true,
        // Barra lateral de solo iconos. Cada uno lleva su tooltip y su
        // aria-label, que es lo que el sistema pide para un icono sin etiqueta.
        showLabels: false,
        panelPos: null,
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Ciclo de vida
    // ─────────────────────────────────────────────────────────────────────────

    /** Primera carga: ajustes y datos locales. Se ejecuta una sola vez. */
    bootstrap() {
        this._migrateLegacyStorage();
        this.settings = this._loadSettings();
        this.favorites = this._loadJson('favorites', {});
        this.customLists = this._loadJson('custom_lists', {});
    },

    /** Aplica un payload `openMenu` de Lua. */
    init(data) {
        this.categories = data.categories || {};
        this.keybinds = data.keybinds || [];
        this.walks = data.walks || [];
        this.expressions = data.expressions || [];
        this.emojis = data.emojis || [];
        this.recents = data.recents || [];
        this.mostUsed = data.mostUsed || [];
        this.playlists = data.playlists || [];
        this.config = data.config || {};
        this.translations = data.translations || {};
        // `searchTerm` NO se reinicia: la busqueda sobrevive a cerrar y volver a
        // abrir el menu, y solo se va cuando el jugador la borra o cambia de
        // categoria. En el primer arranque ya vale '' por su valor inicial.
        this.activeWalk = data.activeWalk || '';
        this.activeWalkLabel = data.activeWalkLabel || '';
        this.walkLock = !!data.walkLock;
        this.walkLockAvailable = !!data.walkLockAvailable;
        this.activeExpression = data.activeExpression || '';
        this.activeExpressionLabel = data.activeExpressionLabel || '';

        // Los valores por defecto de config.lua solo se aplican la primera vez;
        // a partir de ahi manda lo que el jugador haya elegido.
        this._applyServerDefaults(data.config && data.config.ui);

        this._buildLabelMap();
        this._buildSearchIndex();
        this._buildCategoryOrder();

        const saved = localStorage.getItem(this._LS + 'category');
        this.currentCategory = (saved && this.categoryOrder.includes(saved))
            ? saved
            : this.categoryOrder[0] || null;

        this.isOpen = true;
        this._updateFilteredItems();
    },

    /** Refresca solo lo que cambia entre aperturas sin rehacer los indices. */
    updateDynamic(data) {
        if (data.recents) this.recents = data.recents;
        if (data.mostUsed) this.mostUsed = data.mostUsed;
        if (data.keybinds) this.keybinds = data.keybinds;
        if (data.playlists) this.playlists = data.playlists;
    },

    _applyServerDefaults(ui) {
        if (!ui) return;
        if (localStorage.getItem(this._LS + 'settings')) return;

        const next = { ...this.DEFAULT_SETTINGS };
        for (const key of Object.keys(next)) {
            if (ui[key] !== undefined && ui[key] !== null) next[key] = ui[key];
        }
        this.settings = next;
        this.saveSettings();
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Almacenamiento local
    // ─────────────────────────────────────────────────────────────────────────

    /** Scroll recordado de cada categoria. Lo usa Grid. */
    loadScrollPositions() {
        const raw = this._loadJson('scroll', {});
        const clean = {};
        for (const [cat, pos] of Object.entries(raw || {})) {
            const n = Number(pos);
            if (Number.isFinite(n) && n > 0) clean[cat] = n;
        }
        return clean;
    },

    saveScrollPositions(positions) {
        this._saveJson('scroll', positions);
    },

    _loadJson(key, fallback) {
        try {
            const raw = localStorage.getItem(this._LS + key);
            return raw ? (JSON.parse(raw) || fallback) : fallback;
        } catch {
            return fallback;
        }
    },

    _saveJson(key, value) {
        try {
            localStorage.setItem(this._LS + key, JSON.stringify(value));
        } catch {
            /* cuota agotada: preferimos perder el guardado antes que romper el menu */
        }
    },

    /** Importa una sola vez los datos que dejo rpemotes en el mismo navegador. */
    _migrateLegacyStorage() {
        try {
            if (localStorage.getItem(this._LS + 'migrated')) return;
            localStorage.setItem(this._LS + 'migrated', '1');

            for (const key of ['favorites', 'custom_lists', 'category']) {
                const legacy = localStorage.getItem(this._LEGACY_LS + key);
                if (legacy !== null && localStorage.getItem(this._LS + key) === null) {
                    localStorage.setItem(this._LS + key, legacy);
                }
            }
        } catch {
            /* localStorage no disponible */
        }
    },

    _loadSettings() {
        const stored = this._loadJson('settings', null);
        const merged = { ...this.DEFAULT_SETTINGS, ...(stored || {}) };
        const settings = this._sanitizeSettings(this._migrateSettings(merged, stored));

        // La migracion se guarda en el acto. Si se dejase para el primer cambio
        // que haga el jugador, el menu volveria a migrar en cada apertura.
        if (!stored || stored.v !== this.SETTINGS_VERSION) {
            this._saveJson('settings', settings);
        }

        return settings;
    },

    /**
     * Ajustes guardados de una version anterior del menu.
     *
     * Un valor por defecto nuevo no llega a quien ya tiene el ajuste guardado:
     * el merge de arriba deja ganar siempre a lo suyo. Cuando el cambio no es
     * una preferencia sino una decision de diseno -- el acento, que ahora marca
     * la seleccion y por eso no puede ser el amarillo de aviso -- hay que
     * reponerlo a mano. Solo se tocan las claves que cambiaron: la escala, las
     * columnas o el retardo que el jugador haya elegido se respetan.
     */
    _migrateSettings(s, stored) {
        const from = stored ? Number(stored.v) || 1 : this.SETTINGS_VERSION;

        // v2: sistema de diseno de negro neutro. El acento pasa a ser el teal
        // de la seleccion y la barra lateral se queda en solo iconos.
        if (from < 2) {
            s.accent = this.DEFAULT_SETTINGS.accent;
            s.showLabels = this.DEFAULT_SETTINGS.showLabels;
        }

        s.v = this.SETTINGS_VERSION;
        return s;
    },

    _sanitizeSettings(s) {
        const clamp = (v, min, max, fallback) => {
            const n = Number(v);
            return Number.isFinite(n) ? Math.min(max, Math.max(min, n)) : fallback;
        };
        s.columns = clamp(s.columns, 1, 4, 2);
        s.scale = clamp(s.scale, 80, 130, 100);
        s.previewDelay = clamp(s.previewDelay, 0, 2000, 500);

        // Restos de versiones con opacidad y modo compacto ajustables. La
        // opacidad del panel es ahora fija (la misma del inventario) y el modo
        // compacto ya no existe: si se quedasen guardados, volverian a
        // aparecer en el objeto de ajustes cada vez que se exporta el perfil.
        delete s.opacity;
        delete s.compact;
        // El acento ya no es una preferencia: es el teal del sistema de diseno,
        // el que marca lo seleccionado y la accion principal, y elegir otro solo
        // servia para romper esa lectura. Se repone siempre, no solo al migrar:
        // sin el selector no habria forma de recuperarse de un valor guardado de
        // una version anterior, y applySettings lo reinyectaria en linea dejando
        // el menu pintado de un color que el CSS ya no contempla.
        s.accent = this.DEFAULT_SETTINGS.accent;
        for (const flag of ['animations', 'confirmPlay', 'closeOnPlay', 'showRecents', 'showMostUsed', 'showLabels']) {
            s[flag] = !!s[flag];
        }
        return s;
    },

    saveSettings() {
        this._sanitizeSettings(this.settings);
        this._saveJson('settings', this.settings);
    },

    setSetting(key, value) {
        this.settings[key] = value;
        this.saveSettings();
    },

    resetSettings() {
        this.settings = { ...this.DEFAULT_SETTINGS };
        this.saveSettings();
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Indices
    // ─────────────────────────────────────────────────────────────────────────

    _buildLabelMap() {
        this._labelMap = {};
        this._variantMap = {};
        for (const emotes of Object.values(this.categories)) {
            for (const e of emotes) {
                this._labelMap[e.emoteType + '_' + e.name] = e.label || e.name;
                // Las variantes de textura solo viajan en el payload de las
                // categorias de Lua. Favoritos, recientes y listas guardan
                // unicamente name/label/emoteType, asi que hay que reponerlas
                // desde aqui o esas tarjetas se quedan sin selector de color.
                if (e.propVariations) {
                    this._variantMap[e.emoteType + '_' + e.name] = e.propVariations;
                }
            }
        }
        for (const w of this.walks) this._labelMap['Walks_' + w.name] = w.label || w.name;
        for (const e of this.expressions) this._labelMap['Expressions_' + e.name] = e.label || e.name;
        for (const j of this.emojis) this._labelMap['Emojis_' + j.name] = j.label || j.name;
    },

    /**
     * Lista plana y deduplicada de todo lo buscable. Se construye una vez por
     * apertura en lugar de recorrer todas las categorias en cada pulsacion.
     */
    _buildSearchIndex() {
        const index = [];
        const seen = new Set();

        const push = (item) => {
            const key = item.emoteType + ':' + item.name;
            if (seen.has(key)) return;
            seen.add(key);
            index.push(item);
        };

        for (const emotes of Object.values(this.categories)) {
            for (const e of emotes) push(e);
        }
        for (const w of this.walks) {
            push({ name: w.name, label: w.label, emoteType: 'Walks', hasPermission: w.hasPermission !== false, _isWalk: true });
        }
        for (const e of this.expressions) {
            push({ name: e.name, label: e.label, emoteType: 'Expressions', hasPermission: e.hasPermission !== false, _isExpression: true });
        }
        for (const j of this.emojis) {
            push({ name: j.name, label: j.label, emoteType: 'Emojis', _isEmoji: true });
        }

        this._searchIndex = index;
    },

    _buildCategoryOrder() {
        const order = [this.FAVORITES];

        if (this.settings.showRecents && this.recents.length > 0) order.push(this.RECENTS);
        if (this.settings.showMostUsed && this.mostUsed.length > 0) order.push(this.MOST_USED);

        // La playlist va con las listas del jugador, no con las del catalogo:
        // su contenido lo pone el, no el servidor.
        if (this.config.playlistsEnabled) order.push(this.PLAYLISTS);
        for (const id of Object.keys(this.customLists)) order.push(id);
        for (const name of Object.keys(this.categories)) order.push(name);

        if (this.walks.length > 0) order.push(this.WALKS);
        if (this.expressions.length > 0) order.push(this.EXPRESSIONS);
        if (this.emojis.length > 0) order.push(this.EMOJIS);
        // Los atajos van los ultimos: no son animaciones, son la configuracion
        // de las teclas. Entre las categorias de contenido partian la lista en
        // dos sin razon.
        if (this.config.keybindingEnabled) order.push(this.KEYBINDS);

        this.categoryOrder = order;
    },

    rebuildCategoryOrder() {
        this._buildCategoryOrder();
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Etiquetas y presentacion de categorias
    // ─────────────────────────────────────────────────────────────────────────

    _strip(s) {
        return String(s).replace(this._GTA_CODE_RE, '').trim();
    },

    t(key) {
        return this._strip(this.translations[key] || key);
    },

    getCategoryLabel(cat) {
        if (this.isCustomList(cat)) {
            const list = this.customLists[cat];
            return list ? list.name : 'Lista';
        }
        switch (cat) {
            case this.FAVORITES:   return this.t('favorites');
            case this.RECENTS:     return this.t('recents');
            case this.MOST_USED:   return this.t('mostused');
            case this.KEYBINDS:    return this.t('keybinds');
            case this.WALKS:       return this.t('walkingstyles');
            case this.EXPRESSIONS: return this.t('moods');
            case this.EMOJIS:      return this.t('emojis');
            case this.PLAYLISTS:   return this.t('playlists');
            default:               return this._strip(cat);
        }
    },

    getCategoryIcon(cat) {
        if (this.isCustomList(cat)) return 'folder';
        switch (cat) {
            case this.FAVORITES:   return 'star';
            case this.RECENTS:     return 'clock';
            case this.MOST_USED:   return 'fire';
            case this.KEYBINDS:    return 'keyboard';
            case this.WALKS:       return 'walk';
            case this.EXPRESSIONS: return 'masks';
            case this.EMOJIS:      return 'smile';
            case this.PLAYLISTS:   return 'music';
        }

        const t = this.translations;
        if (t.danceemotes && cat === t.danceemotes) return 'music';
        if (t.propemotes && cat === t.propemotes) return 'cube';
        if (t.shareemotes && cat === t.shareemotes) return 'users';
        if (t.animalemotes && cat === t.animalemotes) return 'paw';
        if (t.emotes && cat === t.emotes) return 'play';
        return 'folderOpen';
    },

    /**
      * Color del icono de una categoria en la barra lateral.
      *
      * El sistema de diseno ResetRP es monocromatico: no hay una paleta de doce
      * colores con la que pintar una categoria distinta de cada color, y su
      * regla es que el acento se reserve para el maximo enfasis. Por eso los
      * iconos van en los tonos de la escala del sistema y quien distingue la
      * categoria activa es su fondo con acento, no el color del icono.
      *
      * Las listas personalizadas son la excepcion: el color lo eligio el
      * jugador y esta guardado en su cliente, asi que se respeta tal cual.
      */
    getCategoryColor(cat) {
        // Solo las listas del jugador llevan color propio: lo eligio el y esta
        // guardado en su cliente, asi que es contenido suyo, no cromo nuestro.
        if (this.isCustomList(cat)) {
            const list = this.customLists[cat];
            return list ? list.color : null;
        }

        // El resto hereda el color de su fila, como `.rrp-nav__icon` del
        // sistema: gris en reposo, texto principal en hover y acento cuando
        // esta activa. Un icono de un color por categoria rompe la escala
        // neutra y le quita fuerza al acento, que es lo unico que deberia
        // llamar la atencion.
        return null;
    },

    getCategoryCount(cat) {
        if (cat === this.FAVORITES) return Object.keys(this.favorites).length;
        if (cat === this.RECENTS) return this.recents.length;
        if (cat === this.MOST_USED) return this.mostUsed.length;
        if (this.isCustomList(cat)) {
            const list = this.customLists[cat];
            return list ? Object.keys(list.emotes).length : 0;
        }
        if (cat === this.KEYBINDS) return this.keybinds.length;
        if (cat === this.WALKS) return this.walks.length;
        if (cat === this.EXPRESSIONS) return this.expressions.length;
        if (cat === this.EMOJIS) return this.emojis.length;
        if (cat === this.PLAYLISTS) return this.playlists.length;
        if (this.categories[cat]) return this.categories[cat].length;
        return 0;
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Filtrado
    // ─────────────────────────────────────────────────────────────────────────

    setCategory(cat) {
        this.currentCategory = cat;
        this.searchTerm = '';
        try { localStorage.setItem(this._LS + 'category', cat); } catch {}
        this._updateFilteredItems();
    },

    setSearchTerm(term) {
        this.searchTerm = term;
        this._updateFilteredItems();
    },

    /** Avanza o retrocede por la barra lateral (Tab / Shift+Tab). */
    cycleCategory(delta) {
        if (this.categoryOrder.length === 0) return null;
        const current = this.categoryOrder.indexOf(this.currentCategory);
        const base = current === -1 ? 0 : current;
        const next = (base + delta + this.categoryOrder.length) % this.categoryOrder.length;
        return this.categoryOrder[next];
    },

    _updateFilteredItems() {
        const term = this.searchTerm.toLowerCase().trim();
        if (term) {
            this.filteredItems = this._search(term);
            return;
        }
        this.filteredItems = this._categoryItems(this.currentCategory);
    },

    _search(term) {
        const scored = [];
        for (const item of this._searchIndex) {
            const result = Fuzzy.scoreItem(item, term);
            if (!result) continue;
            scored.push({ ...item, _score: result.score, _ranges: result.ranges });
        }
        scored.sort((a, b) => {
            if (b._score !== a._score) return b._score - a._score;
            // `numeric` para que "Dance Club 2" no caiga detras de "Dance Club 10".
            return (a.label || a.name).localeCompare(b.label || b.name, undefined, { numeric: true });
        });
        return scored;
    },

    _categoryItems(cat) {
        if (cat === this.FAVORITES) {
            return Object.values(this.favorites).map(e => this._enrich(e));
        }

        if (cat === this.RECENTS) {
            return this.recents.map(e => this._enrich(e));
        }

        if (cat === this.MOST_USED) {
            return this.mostUsed.map(e => {
                const item = this._enrich(e);
                item._badge = String(e.count);
                return item;
            });
        }

        if (cat === this.PLAYLISTS) {
            // Estas tarjetas no son animaciones: no pasan por _enrich (que
            // resolveria un label del catalogo que no existe) ni por permisos.
            return this.playlists.map(pl => ({
                name: pl.id,
                label: pl.name,
                emoteType: 'Playlist',
                hasPermission: true,
                _isPlaylist: true,
                _playlist: pl,
                _badge: String((pl.items || []).length),
            }));
        }

        if (this.isCustomList(cat)) {
            const list = this.customLists[cat];
            return list ? Object.values(list.emotes).map(e => this._enrich(e)) : [];
        }

        if (cat === this.KEYBINDS) {
            return this.keybinds.map(kb => ({
                name: kb.emoteName || '',
                label: kb.label || '',
                emoteType: kb.emoteType || '',
                keyLabel: kb.keyLabel || '',
                _isKeybind: true,
                _slot: kb.slot,
                _isEmpty: !kb.emoteName,
                // Un slot puede apuntar a una playlist: sin esta marca la
                // tarjeta intentaria lanzarla como si fuese una animacion
                // suelta y no encontraria nada en el catalogo.
                _isPlaylist: kb.emoteType === 'Playlist',
            }));
        }

        if (cat === this.WALKS) {
            return this.walks.map(w => ({
                name: w.name,
                label: w.label || w.name,
                emoteType: 'Walks',
                hasPermission: w.hasPermission !== false,
                _isWalk: true,
                _isActive: w.name === this.activeWalk,
            }));
        }

        if (cat === this.EXPRESSIONS) {
            return this.expressions.map(e => ({
                name: e.name,
                label: e.label || e.name,
                emoteType: 'Expressions',
                hasPermission: e.hasPermission !== false,
                _isExpression: true,
                _isActive: e.name === this.activeExpression,
            }));
        }

        if (cat === this.EMOJIS) {
            return this.emojis.map(e => ({
                name: e.name,
                label: e.label || e.name,
                emoteType: 'Emojis',
                _isEmoji: true,
            }));
        }

        return this.categories[cat] ? [...this.categories[cat]] : [];
    },

    /**
     * Rellena etiqueta y banderas de tipo en items guardados o venidos de Lua.
     * Favoritos e historial pueden apuntar a emotes que ya no estan disponibles
     * -desactivadas por el servidor, o incompatibles con el modelo actual-: en
     * ese caso la tarjeta se muestra atenuada en lugar de desaparecer sin
     * explicacion.
     */
    _enrich(item) {
        const e = { ...item };
        const key = e.emoteType + '_' + e.name;
        const live = this._labelMap[key];
        if (live) {
            e.label = live;
        } else {
            e.hasPermission = false;
        }
        if (!e.propVariations && this._variantMap[key]) {
            e.propVariations = this._variantMap[key];
        }
        switch (e.emoteType) {
            case 'Walks':
                e._isWalk = true;
                e._isActive = e.name === this.activeWalk;
                break;
            case 'Expressions':
                e._isExpression = true;
                e._isActive = e.name === this.activeExpression;
                break;
            case 'Emojis':
                e._isEmoji = true;
                break;
        }
        return e;
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Favoritos y listas
    // ─────────────────────────────────────────────────────────────────────────

    isFavorite(name, emoteType) {
        return !!this.favorites[emoteType + '_' + name];
    },

    toggleFavorite(id, data) {
        if (this.favorites[id]) {
            delete this.favorites[id];
        } else {
            this.favorites[id] = data;
        }
        this._saveJson('favorites', this.favorites);
        if (this.currentCategory === this.FAVORITES) this._updateFilteredItems();
        return !!this.favorites[id];
    },

    isCustomList(cat) {
        return typeof cat === 'string' && cat.startsWith(this.CUSTOM_PREFIX);
    },

    createCustomList(name, color) {
        const id = this.CUSTOM_PREFIX + Date.now();
        this.customLists[id] = { name, color, emotes: {} };
        this._saveJson('custom_lists', this.customLists);
        this._buildCategoryOrder();
        return id;
    },

    updateCustomList(id, name, color) {
        const list = this.customLists[id];
        if (!list) return;
        list.name = name;
        list.color = color;
        this._saveJson('custom_lists', this.customLists);
    },

    deleteCustomList(id) {
        delete this.customLists[id];
        this._saveJson('custom_lists', this.customLists);
        this._buildCategoryOrder();
        if (this.currentCategory === id) {
            this.setCategory(this.FAVORITES);
        }
    },

    toggleCustomListItem(listId, emoteId, data) {
        const list = this.customLists[listId];
        if (!list) return false;
        if (list.emotes[emoteId]) {
            delete list.emotes[emoteId];
        } else {
            list.emotes[emoteId] = data;
        }
        this._saveJson('custom_lists', this.customLists);
        if (this.currentCategory === listId) this._updateFilteredItems();
        return !!list.emotes[emoteId];
    },

    isInCustomList(listId, name, emoteType) {
        const list = this.customLists[listId];
        return !!(list && list.emotes[emoteType + '_' + name]);
    },

    updateKeybinds(keybinds) {
        this.keybinds = keybinds || [];
        if (this.currentCategory === this.KEYBINDS) this._updateFilteredItems();
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Playlists
    //
    // A diferencia de las listas personalizadas, estas no se guardan aqui: la
    // fuente de verdad es el KVP del cliente, en Lua, porque una playlist tiene
    // que poder lanzarse con el menu cerrado. Este objeto solo mantiene la copia
    // que llego en el payload y la refresca con lo que devuelve cada callback.
    // ─────────────────────────────────────────────────────────────────────────

    getPlaylist(id) {
        return this.playlists.find(pl => pl.id === id) || null;
    },

    /** Refresca la copia local con la lista que devuelve Lua tras cada cambio. */
    setPlaylists(list) {
        this.playlists = Array.isArray(list) ? list : [];
        this._buildCategoryOrder();
        if (this.currentCategory === this.PLAYLISTS) this._updateFilteredItems();
    },

    /** Si una animacion se puede encadenar. Debe coincidir con IsPlaylistable (Lua). */
    isPlaylistable(item) {
        if (!item || item._isPlaylist) return false;
        return ['Emotes', 'Dances', 'PropEmotes', 'AnimalEmotes'].includes(item.emoteType);
    },

    /** Paso nuevo a partir de una tarjeta del menu. */
    newPlaylistItem(item) {
        return {
            name: item.name,
            emoteType: item.emoteType,
            label: item.label || item.name,
            duration: this.config.playlistDefaultDuration || 5000,
        };
    },

    // ─────────────────────────────────────────────────────────────────────────
    // Perfil exportable
    // ─────────────────────────────────────────────────────────────────────────

    /** Serializa favoritos, listas y ajustes para copiarlos entre servidores. */
    exportProfile() {
        return JSON.stringify({
            _format: 'dwkemotes-profile',
            _version: 1,
            favorites: this.favorites,
            customLists: this.customLists,
            playlists: this.playlists,
            settings: this.settings,
        }, null, 2);
    },

    /**
     * @param {string} raw JSON producido por exportProfile
     * @returns {{ok: boolean, error?: string}}
     */
    importProfile(raw) {
        let data;
        try {
            data = JSON.parse(raw);
        } catch {
            return { ok: false, error: 'json' };
        }
        if (!data || data._format !== 'dwkemotes-profile') {
            return { ok: false, error: 'format' };
        }

        if (data.favorites && typeof data.favorites === 'object') {
            this.favorites = data.favorites;
            this._saveJson('favorites', this.favorites);
        }
        if (data.customLists && typeof data.customLists === 'object') {
            this.customLists = data.customLists;
            this._saveJson('custom_lists', this.customLists);
        }
        if (data.settings && typeof data.settings === 'object') {
            this.settings = this._sanitizeSettings({ ...this.DEFAULT_SETTINGS, ...data.settings });
            this.saveSettings();
        }
        // Las playlists las guarda Lua, asi que la importacion tiene que bajar
        // hasta alli; la copia local se refresca con lo que responda.
        if (Array.isArray(data.playlists)) {
            NUI.replacePlaylists(data.playlists).then(resp => {
                if (resp && resp.playlists) {
                    this.setPlaylists(resp.playlists);
                    if (typeof App !== 'undefined') App.refreshCurrentView();
                }
            });
        }

        this._buildCategoryOrder();
        this._updateFilteredItems();
        return { ok: true };
    }
};
