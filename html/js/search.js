/**
 * dwkemotes - Buscador
 * -----------------------------------------------------------------------------
 * El campo de texto solo orquesta: la puntuacion vive en Fuzzy y el filtrado en
 * Store. El debounce se acorta para consultas largas, donde el conjunto de
 * candidatos ya es pequeño y la respuesta inmediata se agradece.
 */
const Search = {
    _timer: null,
    _input: null,

    init() {
        this._input = document.getElementById('search-input');
        const clearBtn = document.getElementById('search-clear');
        if (!this._input) return;

        this._input.addEventListener('input', (e) => {
            const value = e.target.value;
            this._toggleClear(value);
            this._debounce(value);
        });

        this._input.addEventListener('keydown', (e) => {
            // Las teclas repetidas dentro de la NUI llegan duplicadas al juego.
            if (e.repeat && e.key.length === 1) {
                e.preventDefault();
                return;
            }
            if (e.key === 'Escape') {
                e.preventDefault();
                e.stopPropagation();
                if (this._input.value) {
                    this.clear();
                    this._apply('');
                } else {
                    this._input.blur();
                    NUI.closeMenu();
                }
                return;
            }
            if (e.key === 'ArrowDown' || e.key === 'Enter') {
                e.preventDefault();
                this._input.blur();
                if (e.key === 'ArrowDown') {
                    Grid.navigateEdge(false);
                } else {
                    Grid.navigateEdge(false);
                    Grid.activateSelected();
                }
            }
        });

        this._input.addEventListener('focus', () => NUI.searchFocus());
        this._input.addEventListener('blur', () => NUI.searchBlur());

        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                this.clear();
                this._apply('');
                this._input.focus();
            });
        }
    },

    focus() {
        if (this._input) this._input.select();
        if (this._input) this._input.focus();
    },

    isFocused() {
        return this._input && document.activeElement === this._input;
    },

    _toggleClear(value) {
        const btn = document.getElementById('search-clear');
        if (btn) btn.classList.toggle('hidden', !value);
    },

    _debounce(term) {
        clearTimeout(this._timer);
        const delay = term.length >= 3 ? 60 : 130;
        this._timer = setTimeout(() => this._apply(term), delay);
    },

    _apply(term) {
        Store.setSearchTerm(term);
        Grid.render();
        App.updateSidebar();
    },

    clear() {
        if (this._input) this._input.value = '';
        clearTimeout(this._timer);
        this._toggleClear('');
        Store.setSearchTerm('');
    }
};
