/**
 * dwkemotes - Motor de busqueda
 * -----------------------------------------------------------------------------
 * El menu original filtraba con `String.includes`, asi que "dance" y "linedance"
 * pesaban lo mismo y no habia forma de encontrar "cross arms" escribiendo "cra".
 *
 * Aqui se puntua cada candidato y se devuelven ademas los tramos que han
 * coincidido, para poder resaltarlos. La escala de puntuacion, de mejor a peor:
 *
 *   1000  coincidencia exacta
 *    900  prefijo de la cadena
 *    800  prefijo de alguna palabra
 *    700  subcadena en cualquier posicion
 *    500  iniciales ("cross arms" <- "ca")
 *    300  subsecuencia difusa ("crossarms" <- "cra")
 *
 * Dentro de cada tramo se penaliza la longitud del candidato, de modo que a
 * igualdad de tipo de coincidencia gana el nombre mas corto.
 */
const Fuzzy = {
    // Separadores que marcan el comienzo de una palabra
    _BOUNDARY: /[\s\-_/.()[\]&,:]/,

    /**
     * @param {string} text  Texto candidato
     * @param {string} query Consulta ya en minusculas y sin espacios sobrantes
     * @returns {{score: number, ranges: Array<[number, number]>}|null}
     */
    match(text, query) {
        if (!query) return { score: 0, ranges: [] };
        if (!text) return null;

        const lower = text.toLowerCase();
        const lenPenalty = Math.min(99, text.length);

        if (lower === query) {
            return { score: 1000, ranges: [[0, query.length]] };
        }

        if (lower.startsWith(query)) {
            return { score: 900 - lenPenalty / 100, ranges: [[0, query.length]] };
        }

        // Prefijo de palabra: "line dance" encontrado con "dan"
        const wordStart = this._wordPrefixIndex(lower, query);
        if (wordStart !== -1) {
            return { score: 800 - lenPenalty / 100, ranges: [[wordStart, wordStart + query.length]] };
        }

        const idx = lower.indexOf(query);
        if (idx !== -1) {
            return { score: 700 - idx - lenPenalty / 100, ranges: [[idx, idx + query.length]] };
        }

        const initials = this._initialsMatch(lower, query);
        if (initials) {
            return { score: 500 - lenPenalty / 100, ranges: initials };
        }

        return this._subsequence(lower, query, lenPenalty);
    },

    /** Indice donde `query` empieza justo tras un separador. */
    _wordPrefixIndex(lower, query) {
        let from = 0;
        for (;;) {
            const idx = lower.indexOf(query, from);
            if (idx <= 0) return idx === 0 ? 0 : -1;
            if (this._BOUNDARY.test(lower[idx - 1])) return idx;
            from = idx + 1;
        }
    },

    /** Coincidencia por iniciales de palabra: "cross arms" <- "ca". */
    _initialsMatch(lower, query) {
        const starts = [];
        for (let i = 0; i < lower.length; i++) {
            if (i === 0 || this._BOUNDARY.test(lower[i - 1])) starts.push(i);
        }
        if (starts.length < query.length) return null;

        const ranges = [];
        let q = 0;
        for (const pos of starts) {
            if (lower[pos] === query[q]) {
                ranges.push([pos, pos + 1]);
                q++;
                if (q === query.length) return ranges;
            }
        }
        return null;
    },

    /** Subsecuencia en orden, premiando los caracteres consecutivos. */
    _subsequence(lower, query, lenPenalty) {
        const ranges = [];
        let q = 0;
        let streak = 0;
        let bonus = 0;
        let runStart = -1;

        for (let i = 0; i < lower.length && q < query.length; i++) {
            if (lower[i] !== query[q]) {
                if (runStart !== -1) {
                    ranges.push([runStart, i]);
                    runStart = -1;
                }
                streak = 0;
                continue;
            }

            if (runStart === -1) runStart = i;
            streak++;
            bonus += streak;
            if (i === 0 || this._BOUNDARY.test(lower[i - 1])) bonus += 4;
            q++;
        }

        if (q < query.length) return null;
        if (runStart !== -1) ranges.push([runStart, runStart + streak]);

        return { score: 300 + Math.min(80, bonus) - lenPenalty / 100, ranges };
    },

    /**
     * Puntua un elemento por su etiqueta y su nombre interno, quedandose con la
     * mejor de las dos. El nombre interno pesa un poco menos porque es el que el
     * jugador ve en el comando, no en la tarjeta.
     * @returns {{score: number, ranges: Array<[number, number]>}|null}
     */
    scoreItem(item, query) {
        const label = item.label || item.name || '';
        const best = this.match(label, query);

        const byName = item.name && item.name !== label
            ? this.match(item.name, query)
            : null;

        if (byName && (!best || byName.score - 20 > best.score)) {
            return { score: byName.score - 20, ranges: [], matchedName: true };
        }
        return best;
    },

    /**
     * Construye los nodos de texto de una etiqueta con los tramos resaltados.
     * @param {string} text
     * @param {Array<[number, number]>} ranges
     * @returns {DocumentFragment}
     */
    highlight(text, ranges) {
        const frag = document.createDocumentFragment();
        if (!ranges || ranges.length === 0) {
            frag.appendChild(document.createTextNode(text));
            return frag;
        }

        let cursor = 0;
        for (const [start, end] of ranges) {
            if (start > cursor) {
                frag.appendChild(document.createTextNode(text.slice(cursor, start)));
            }
            const mark = document.createElement('mark');
            mark.className = 'hl';
            mark.textContent = text.slice(start, end);
            frag.appendChild(mark);
            cursor = end;
        }
        if (cursor < text.length) {
            frag.appendChild(document.createTextNode(text.slice(cursor)));
        }
        return frag;
    }
};
