/**
 * dwkemotes - Desplazamiento suave
 * -----------------------------------------------------------------------------
 * La rueda del raton se interpola hacia un objetivo en vez de saltar. Cuando el
 * jugador desactiva las animaciones -o el sistema pide movimiento reducido- se
 * salta la interpolacion y se escribe scrollTop directamente.
 *
 * El bucle de animacion se detiene solo; no hay rAF corriendo con el menu
 * cerrado.
 */
const SmoothScroll = {
    _el: null,
    _target: 0,
    _current: 0,
    _animating: false,
    _lerp: 0.16,
    _wheelMultiplier: 0.5,

    init(el) {
        this._el = el;
        this._current = 0;
        this._target = 0;

        el.addEventListener('wheel', (e) => {
            e.preventDefault();
            e.stopPropagation();

            let delta = e.deltaY;
            if (e.deltaMode === 1) delta *= 36;       // lineas
            else if (e.deltaMode === 2) delta *= el.clientHeight; // paginas
            delta *= this._wheelMultiplier;

            const max = this._max();

            if (!this._enabled()) {
                el.scrollTop = Math.max(0, Math.min(max, el.scrollTop + delta));
                this._target = el.scrollTop;
                this._current = el.scrollTop;
                return;
            }

            // Si venimos de un salto externo, resincronizamos antes de acumular.
            if (!this._animating) this._current = el.scrollTop;

            this._target = Math.max(0, Math.min(max, this._target + delta));
            if (!this._animating) this._animate();
        }, { passive: false });
    },

    _enabled() {
        if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return false;
        return Store.settings ? Store.settings.animations !== false : true;
    },

    _max() {
        return Math.max(0, this._el.scrollHeight - this._el.clientHeight);
    },

    _animate() {
        this._animating = true;

        const tick = () => {
            if (!this._animating) return;

            const diff = this._target - this._current;
            if (Math.abs(diff) < 0.5) {
                this._current = this._target;
                this._el.scrollTop = this._current;
                this._animating = false;
                return;
            }

            this._current += diff * this._lerp;
            this._el.scrollTop = Math.round(this._current);
            requestAnimationFrame(tick);
        };

        requestAnimationFrame(tick);
    },

    reset() {
        this.jumpTo(0);
    },

    /**
     * Salta a una posicion sin interpolar y deja el estado interno coherente.
     *
     * Escribir `scrollTop` a pelo no basta: `_target` se quedaria en el valor
     * viejo y la primera vuelta de rueda despues del salto tiraria hacia alli.
     */
    jumpTo(pos) {
        this._animating = false;
        if (!this._el) return;

        const clamped = Math.max(0, Math.min(this._max(), pos || 0));
        this._el.scrollTop = clamped;
        this._current = clamped;
        this._target = clamped;
    },

    scrollTo(pos) {
        const clamped = Math.max(0, Math.min(this._max(), pos));
        this._target = clamped;

        if (!this._enabled()) {
            this._current = clamped;
            this._el.scrollTop = clamped;
            return;
        }

        if (!this._animating) {
            this._current = this._el.scrollTop;
            this._animate();
        }
    },

    /** Detiene el bucle al cerrar el menu para no dejar rAF colgando. */
    stop() {
        this._animating = false;
    }
};
