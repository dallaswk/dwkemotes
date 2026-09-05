/**
 * dwkemotes - Editor de props
 * -----------------------------------------------------------------------------
 * Interfaz del editor que abre `/propeditor`. Se monta sola en <body> la primera
 * vez que el cliente manda `propeditor:open` y se queda oculta el resto del
 * tiempo, así que mientras no se use no pinta ni escucha nada del menú.
 *
 * Vive fuera de html/js/ a propósito: todo lo del editor cabe en propeditor/, y
 * si ese directorio se quita, este fichero da 404 y el menú sigue igual.
 *
 * Reparto de trabajo con el cliente Lua:
 *   - Lua manda las coordenadas de pantalla de cada hueso en cada frame; aquí
 *     solo se colocan los puntos y se avisa de en cuál se ha pinchado.
 *   - Lua es el dueño de los valores. Esta interfaz nunca los guarda por su
 *     cuenta: los manda, y espera el `propeditor:state` de vuelta.
 */
(function () {
    'use strict';

    const RESOURCE = (typeof GetParentResourceName === 'function')
        ? GetParentResourceName()
        : 'dwkemotes';

    /** Igual que html/js/nui.js: nunca rechaza, para no dejar la interfaz a medias. */
    function post(name, data) {
        return fetch(`https://${RESOURCE}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data || {})
        })
            .then(r => (r.ok ? r.json() : {}))
            .catch(() => ({}));
    }

    const AXES = ['x', 'y', 'z'];

    const PropEditor = {
        root: null,
        el: {},

        /** Última foto mandada por Lua. Solo se lee; quien manda es el cliente. */
        state: null,
        props: [],
        bones: [],
        limitPos: 1.5,

        /** Puntos de hueso ya pintados, por id, para no rehacer el DOM cada frame. */
        dots: new Map(),

        filter: '',
        boneFilter: '',

        /**
         * Firma de lo último que se pintó en las listas. `apply()` entra en cada
         * frame mientras se mueve el prop con el teclado: sin esto se repintarían
         * 120 filas y se lanzaría una validación de modelo sesenta veces por
         * segundo. Los deslizadores sí se refrescan siempre, que es barato.
         */
        renderKey: '',

        // ─── Montaje ────────────────────────────────────────────────────────

        build() {
            if (this.root) return;

            const root = document.createElement('div');
            root.id = 'propeditor';
            root.className = 'hidden';
            root.innerHTML = `
                <div class="pe-stage" id="pe-stage">
                    <div class="pe-bones" id="pe-bones"></div>
                </div>

                <div class="pe-header">
                    <span class="pe-header-title" id="pe-emote-label"></span>
                    <span class="pe-header-name" id="pe-emote-name"></span>
                    <span class="pe-dirty" id="pe-dirty">sin guardar</span>
                </div>

                <div class="pe-hints">
                    <div class="pe-hint"><span class="pe-key">W</span><span class="pe-key">S</span><span class="pe-key">A</span><span class="pe-key">D</span><span class="pe-key">R</span><span class="pe-key">F</span> mover el prop</div>
                    <div class="pe-hint"><span class="pe-key">Ctrl</span> + esas mismas teclas: girar</div>
                    <div class="pe-hint"><span class="pe-key">Shift</span> paso grueso</div>
                    <div class="pe-hint">Arrastrar el fondo o <span class="pe-key">&larr;</span><span class="pe-key">&rarr;</span><span class="pe-key">&uarr;</span><span class="pe-key">&darr;</span> orbitar &middot; rueda: zoom</div>
                    <div class="pe-hint"><span class="pe-key">Tab</span> cambiar de prop &middot; <span class="pe-key">Enter</span> guardar &middot; <span class="pe-key">Retroceso</span> salir</div>
                </div>

                <div class="pe-panel">
                    <div class="pe-panel-body">
                        <div class="pe-slots">
                            <button class="pe-slot-tab" type="button" data-slot="1">
                                <span class="pe-slot-tab-name">Prop 1</span>
                                <span class="pe-slot-tab-model" id="pe-slot1-model">vacío</span>
                            </button>
                            <button class="pe-slot-tab" type="button" data-slot="2">
                                <span class="pe-slot-tab-name">Prop 2</span>
                                <span class="pe-slot-tab-model" id="pe-slot2-model">vacío</span>
                            </button>
                        </div>

                        <div class="pe-section">
                            <div class="pe-section-title">
                                <span>Modelo</span>
                                <button class="pe-btn pe-btn-small pe-btn-danger" type="button" id="pe-remove">Quitar</button>
                            </div>
                            <input class="pe-input" type="text" id="pe-model" autocomplete="off"
                                   spellcheck="false" placeholder="Buscar o escribir un modelo" />
                            <div class="pe-model-status" id="pe-model-status"></div>
                            <div class="pe-list" id="pe-props"></div>
                        </div>

                        <div class="pe-section">
                            <div class="pe-section-title">
                                <span>Hueso &middot; <span id="pe-bone-current"></span></span>
                                <label class="pe-check">
                                    <input type="checkbox" id="pe-all-bones" /> todos
                                </label>
                            </div>
                            <input class="pe-input" type="text" id="pe-bone-search" autocomplete="off"
                                   spellcheck="false" placeholder="Buscar hueso, o pinchar un punto" />
                            <div class="pe-list" id="pe-bone-list"></div>
                        </div>

                        <div class="pe-section">
                            <div class="pe-section-title"><span>Posición (m)</span></div>
                            <div id="pe-pos"></div>
                        </div>

                        <div class="pe-section">
                            <div class="pe-section-title"><span>Rotación (grados)</span></div>
                            <div id="pe-rot"></div>
                        </div>

                        <div class="pe-section">
                            <label class="pe-check">
                                <input type="checkbox" id="pe-nocollision" /> Sin colisión al reproducir la emote
                            </label>
                            <label class="pe-check">
                                <input type="checkbox" id="pe-follow" /> La cámara sigue al hueso elegido
                            </label>
                        </div>
                    </div>

                    <div class="pe-actions">
                        <button class="pe-btn" type="button" id="pe-reset">Restablecer</button>
                        <button class="pe-btn" type="button" id="pe-close">Salir</button>
                        <button class="pe-btn pe-btn-primary" type="button" id="pe-save">Guardar</button>
                    </div>
                </div>
            `;

            document.body.appendChild(root);
            this.root = root;

            const id = x => root.querySelector('#' + x);
            this.el = {
                stage: id('pe-stage'),
                bones: id('pe-bones'),
                emoteLabel: id('pe-emote-label'),
                emoteName: id('pe-emote-name'),
                dirty: id('pe-dirty'),
                slotModels: [id('pe-slot1-model'), id('pe-slot2-model')],
                model: id('pe-model'),
                modelStatus: id('pe-model-status'),
                props: id('pe-props'),
                boneCurrent: id('pe-bone-current'),
                boneSearch: id('pe-bone-search'),
                boneList: id('pe-bone-list'),
                allBones: id('pe-all-bones'),
                pos: id('pe-pos'),
                rot: id('pe-rot'),
                noCollision: id('pe-nocollision'),
                follow: id('pe-follow'),
            };

            this.buildAxes();
            this.bind();
        },

        /** Las seis filas de deslizador + número. Se generan porque son iguales. */
        buildAxes() {
            const make = (kind, axis) => {
                const row = document.createElement('div');
                row.className = 'pe-axis';
                row.dataset.axis = axis;

                const isPos = kind === 'pos';
                row.innerHTML = `
                    <span class="pe-axis-label">${axis.toUpperCase()}</span>
                    <input class="pe-range" type="range"
                           min="${isPos ? -this.limitPos : 0}"
                           max="${isPos ? this.limitPos : 360}"
                           step="${isPos ? 0.005 : 1}" value="0" />
                    <input class="pe-number" type="number"
                           step="${isPos ? 0.005 : 1}" value="0" />
                `;

                const range = row.querySelector('.pe-range');
                const number = row.querySelector('.pe-number');

                const send = value => {
                    const payload = { pos: {}, rot: {} };
                    payload[kind][axis] = value;
                    post('propEditorSetTransform', payload);
                };

                range.addEventListener('input', () => {
                    number.value = range.value;
                    send(parseFloat(range.value));
                });

                number.addEventListener('change', () => {
                    const value = parseFloat(number.value);
                    if (Number.isNaN(value)) return;
                    range.value = value;
                    send(value);
                });

                this.el[kind + axis.toUpperCase()] = { range, number };
                return row;
            };

            for (const axis of AXES) {
                this.el.pos.appendChild(make('pos', axis));
                this.el.rot.appendChild(make('rot', axis));
            }
        },

        bind() {
            const el = this.el;

            // Pestañas de slot
            this.root.querySelectorAll('.pe-slot-tab').forEach(tab => {
                tab.addEventListener('click', () => post('propEditorSetSlot', { slot: Number(tab.dataset.slot) }));
            });

            // Buscador de modelos: filtra la lista y, con Enter, acepta lo escrito
            // aunque no esté en ella (cualquier modelo del juego vale).
            el.model.addEventListener('input', () => {
                this.filter = el.model.value.trim().toLowerCase();
                this.renderProps();
                this.validateModel(el.model.value.trim());
            });

            el.model.addEventListener('keydown', e => {
                if (e.key !== 'Enter') return;
                e.preventDefault();
                post('propEditorSetModel', { model: el.model.value.trim() });
            });

            el.boneSearch.addEventListener('input', () => {
                this.boneFilter = el.boneSearch.value.trim().toLowerCase();
                this.renderBoneList();
            });

            // Mientras se escribe hay que soltarle el teclado entero al CEF; si no,
            // cada letra movería también el prop.
            [el.model, el.boneSearch].forEach(input => {
                input.addEventListener('focus', () => post('propEditorInputFocus', { focused: true }));
                input.addEventListener('blur', () => post('propEditorInputFocus', { focused: false }));
            });

            el.allBones.addEventListener('change', () => post('propEditorToggle', { key: 'showAllBones' }));
            el.follow.addEventListener('change', () => post('propEditorToggle', { key: 'followBone' }));
            el.noCollision.addEventListener('change',
                () => post('propEditorSetTransform', { noCollision: el.noCollision.checked }));

            this.root.querySelector('#pe-remove').addEventListener('click', () => post('propEditorRemove'));
            this.root.querySelector('#pe-reset').addEventListener('click', () => post('propEditorResetSlot'));
            this.root.querySelector('#pe-save').addEventListener('click', () => post('propEditorSave'));
            this.root.querySelector('#pe-close').addEventListener('click', () => post('propEditorClose'));

            this.bindOrbit();
        },

        /**
         * Orbitar arrastrando sobre el fondo. Los deltas se acumulan y se mandan
         * una vez por frame: un `fetch` por cada mousemove ahogaría al recurso.
         */
        bindOrbit() {
            const stage = this.el.stage;
            let dragging = false;
            let dx = 0, dy = 0, queued = false;

            const flush = () => {
                queued = false;
                if (dx === 0 && dy === 0) return;
                post('propEditorOrbit', { dx, dy });
                dx = 0;
                dy = 0;
            };

            stage.addEventListener('mousedown', e => {
                if (e.target !== stage) return; // los puntos de hueso son suyos
                dragging = true;
                stage.classList.add('dragging');
            });

            window.addEventListener('mouseup', () => {
                dragging = false;
                stage.classList.remove('dragging');
            });

            window.addEventListener('mousemove', e => {
                if (!dragging) return;
                dx += e.movementX;
                dy += e.movementY;
                if (!queued) {
                    queued = true;
                    requestAnimationFrame(flush);
                }
            });

            stage.addEventListener('wheel', e => {
                e.preventDefault();
                post('propEditorZoom', { delta: e.deltaY });
            }, { passive: false });
        },

        // ─── Estado ─────────────────────────────────────────────────────────

        open(data) {
            this.build();

            this.props = data.props || [];
            this.bones = data.bones || [];
            this.limitPos = data.limitPos || 1.5;
            this.filter = '';
            this.boneFilter = '';
            this.renderKey = '';

            for (const axis of AXES) {
                const range = this.el['pos' + axis.toUpperCase()].range;
                range.min = -this.limitPos;
                range.max = this.limitPos;
            }

            this.el.emoteLabel.textContent = data.label || data.emote || '';
            this.el.emoteName.textContent = data.emote || '';
            this.el.model.value = '';
            this.el.boneSearch.value = '';
            this.el.modelStatus.textContent = '';
            this.el.modelStatus.className = 'pe-model-status';

            this.renderProps();
            this.renderBoneList();

            this.root.classList.remove('hidden');
        },

        close() {
            if (!this.root) return;
            this.root.classList.add('hidden');
            this.el.bones.innerHTML = '';
            this.dots.clear();
        },

        /** Los puntos llegan como [id, x, y] con x/y normalizados (0..1). */
        updateBones(points) {
            if (!this.root || this.root.classList.contains('hidden')) return;

            const layer = this.el.bones;
            const current = this.state ? this.state.slots[this.state.slot - 1].bone : null;
            const alive = new Set();

            for (const [id, x, y] of points) {
                alive.add(id);

                let dot = this.dots.get(id);
                if (!dot) {
                    dot = document.createElement('div');
                    dot.className = 'pe-bone';
                    dot.dataset.label = this.boneName(id);
                    dot.addEventListener('click', () => post('propEditorSetBone', { bone: id }));
                    layer.appendChild(dot);
                    this.dots.set(id, dot);
                }

                dot.style.left = (x * 100) + '%';
                dot.style.top = (y * 100) + '%';
                dot.classList.toggle('active', id === current);
            }

            // Un hueso que se va detrás de la cámara deja de venir en la lista.
            for (const [id, dot] of this.dots) {
                if (!alive.has(id)) {
                    dot.remove();
                    this.dots.delete(id);
                }
            }
        },

        apply(state) {
            if (!this.root) return;
            this.state = state;

            const slot = state.slots[state.slot - 1];
            const el = this.el;

            this.root.querySelectorAll('.pe-slot-tab').forEach(tab => {
                tab.classList.toggle('active', Number(tab.dataset.slot) === state.slot);
            });

            state.slots.forEach((data, index) => {
                el.slotModels[index].textContent = data.model || 'vacío';
            });

            el.boneCurrent.textContent = slot.boneLabel || '';
            el.dirty.classList.toggle('show', !!state.dirty);
            el.noCollision.checked = !!slot.noCollision;
            el.follow.checked = !!state.followBone;
            el.allBones.checked = !!state.showAllBones;

            for (const axis of AXES) {
                const upper = axis.toUpperCase();
                this.setAxis(el['pos' + upper], slot.pos[axis]);
                this.setAxis(el['rot' + upper], slot.rot[axis]);
            }

            // De aquí abajo solo cuando cambia algo que se ve en las listas.
            const key = [state.slot, slot.model, slot.bone, state.showAllBones].join('|');
            if (key === this.renderKey) return;
            this.renderKey = key;

            // El campo de texto no se pisa mientras se está escribiendo en él.
            if (document.activeElement !== el.model) {
                el.model.value = slot.model || '';
                this.filter = (slot.model || '').toLowerCase();
                this.validateModel(slot.model);
            }

            this.renderProps();
            this.renderBoneList();
        },

        setAxis(pair, value) {
            pair.range.value = value;
            if (document.activeElement !== pair.number) {
                pair.number.value = value;
            }
        },

        // ─── Pintado de listas ──────────────────────────────────────────────

        boneName(id) {
            const bone = this.bones.find(b => b.id === id);
            return bone ? `${bone.label} · ${bone.name}` : `Hueso ${id}`;
        },

        /**
         * La lista se recorta a 120 filas: el catálogo pasa de 300 modelos y
         * pintarlos todos en cada tecla se nota en el CEF. Lo que no cabe se
         * encuentra afinando la búsqueda.
         */
        renderProps() {
            const current = this.state ? this.state.slots[this.state.slot - 1].model : '';
            const needle = this.filter;
            const matches = this.props.filter(p => !needle || p.model.includes(needle));

            this.el.props.innerHTML = '';

            if (matches.length === 0) {
                this.el.props.innerHTML =
                    '<div class="pe-empty">Ningún modelo del catálogo coincide.<br>Escríbelo entero y pulsa Enter.</div>';
                return;
            }

            const frag = document.createDocumentFragment();

            for (const prop of matches.slice(0, 120)) {
                const row = document.createElement('button');
                row.type = 'button';
                row.className = 'pe-row' + (prop.model === current ? ' active' : '');
                row.innerHTML = `
                    <span class="pe-row-model">${prop.model}</span>
                    <span class="pe-tag ${prop.source === 'pack' ? 'pack' : ''}">${prop.source === 'pack' ? 'pack' : 'base'}</span>
                `;
                row.addEventListener('click', () => post('propEditorSetModel', { model: prop.model }));
                frag.appendChild(row);
            }

            this.el.props.appendChild(frag);

            if (matches.length > 120) {
                const more = document.createElement('div');
                more.className = 'pe-empty';
                more.textContent = `y ${matches.length - 120} más — afina la búsqueda`;
                this.el.props.appendChild(more);
            }
        },

        renderBoneList() {
            const current = this.state ? this.state.slots[this.state.slot - 1].bone : null;
            const needle = this.boneFilter;
            const showAll = this.state ? this.state.showAllBones : false;

            const matches = this.bones.filter(b => {
                if (needle) {
                    return b.label.toLowerCase().includes(needle)
                        || b.name.toLowerCase().includes(needle)
                        || String(b.id).includes(needle);
                }
                return showAll || b.major || b.id === current;
            });

            this.el.boneList.innerHTML = '';

            if (matches.length === 0) {
                this.el.boneList.innerHTML = '<div class="pe-empty">Ningún hueso coincide.</div>';
                return;
            }

            const frag = document.createDocumentFragment();

            for (const bone of matches) {
                const row = document.createElement('button');
                row.type = 'button';
                row.className = 'pe-row' + (bone.id === current ? ' active' : '');
                row.innerHTML = `
                    <span class="pe-row-model">${bone.label}</span>
                    <span class="pe-tag">${bone.group}</span>
                `;
                row.addEventListener('click', () => post('propEditorSetBone', { bone: bone.id }));
                frag.appendChild(row);
            }

            this.el.boneList.appendChild(frag);
        },

        /** El juego es quien sabe si un modelo existe en este servidor. */
        validateModel(model) {
            const status = this.el.modelStatus;

            if (!model) {
                status.textContent = '';
                status.className = 'pe-model-status';
                this.el.model.classList.remove('invalid');
                return;
            }

            post('propEditorValidateModel', { model }).then(res => {
                // Entre la ida y la vuelta se puede haber seguido escribiendo.
                if (this.el.model.value.trim() !== model) return;

                const valid = !!res.valid;
                status.textContent = valid
                    ? 'El modelo existe en este servidor'
                    : 'Este servidor no tiene ese modelo';
                status.className = 'pe-model-status ' + (valid ? 'ok' : 'bad');
                this.el.model.classList.toggle('invalid', !valid);
            });
        },
    };

    window.addEventListener('message', event => {
        const data = event.data;
        if (!data || typeof data.action !== 'string') return;
        if (!data.action.startsWith('propeditor:')) return;

        switch (data.action) {
            case 'propeditor:open':  PropEditor.open(data); break;
            case 'propeditor:state': PropEditor.apply(data); break;
            case 'propeditor:bones': PropEditor.updateBones(data.points || []); break;
            case 'propeditor:close': PropEditor.close(); break;
        }
    });
})();
