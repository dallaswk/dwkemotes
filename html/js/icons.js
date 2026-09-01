/**
 * dwkemotes - Iconos
 * -----------------------------------------------------------------------------
 * El menu original cargaba Font Awesome desde un CDN. Dentro de la NUI de FiveM
 * eso significa una peticion externa en cada apertura del recurso: falla sin
 * salida a internet y, cuando funciona, los iconos aparecen despues del primer
 * pintado. Aqui los trazos viajan con el recurso y se montan una sola vez como
 * <symbol>, de modo que cada tarjeta solo necesita un <use>.
 *
 * Todos los trazos estan normalizados a un viewBox de 24x24.
 */
const Icons = {
    _mounted: false,

    // Trazos solidos (fill)
    _fill: {
        star: 'M12 2.6l2.9 5.9 6.5.9-4.7 4.6 1.1 6.4L12 17.4 6.2 20.4l1.1-6.4L2.6 9.4l6.5-.9z',
        heart: 'M12 20.5l-1.4-1.3C5.4 14.5 2 11.4 2 7.6 2 4.9 4.1 3 6.8 3c1.6 0 3.1.7 4 1.9l1.2 1.5 1.2-1.5c.9-1.2 2.4-1.9 4-1.9C19.9 3 22 4.9 22 7.6c0 3.8-3.4 6.9-8.6 11.6z',
        fire: 'M12 2c.6 3.1-1 4.6-2.4 6C8 9.6 6.6 11 6.6 13.6a5.4 5.4 0 0010.8 0c0-1.5-.5-2.6-1.3-3.6-.2 1-.9 1.8-1.8 1.8 1-3.6-.6-7.4-2.3-9.8z',
        bolt: 'M13.5 2L4 13.5h6L9.5 22 20 10.5h-6z',
        play: 'M8 5.2v13.6c0 .8.9 1.3 1.6.9l10.2-6.8a1 1 0 000-1.8L9.6 4.3A1 1 0 008 5.2z',
        circleCheck: 'M12 2a10 10 0 100 20 10 10 0 000-20zm4.7 7.7l-5.6 5.6a1 1 0 01-1.4 0L7.3 13a1 1 0 011.4-1.4l1.7 1.7 4.9-4.9a1 1 0 011.4 1.4z',
        circleX: 'M12 2a10 10 0 100 20 10 10 0 000-20zm3.5 12.1a1 1 0 01-1.4 1.4L12 13.4l-2.1 2.1a1 1 0 01-1.4-1.4l2.1-2.1-2.1-2.1a1 1 0 011.4-1.4l2.1 2.1 2.1-2.1a1 1 0 011.4 1.4L13.4 12z',
        circleInfo: 'M12 2a10 10 0 100 20 10 10 0 000-20zm0 4.2a1.3 1.3 0 110 2.6 1.3 1.3 0 010-2.6zM13.2 17h-2.4v-6.4h2.4z',
        warning: 'M12.9 3.6l8.4 14.6a1 1 0 01-.9 1.5H3.6a1 1 0 01-.9-1.5l8.4-14.6a1 1 0 011.8 0zM11 9v5h2V9zm0 6.6v2h2v-2z',
        paw: 'M6.5 12.5a2.6 2.6 0 100-5.2 2.6 2.6 0 000 5.2zm11 0a2.6 2.6 0 100-5.2 2.6 2.6 0 000 5.2zM9.8 7.6a2.4 2.4 0 100-4.8 2.4 2.4 0 000 4.8zm4.4 0a2.4 2.4 0 100-4.8 2.4 2.4 0 000 4.8zM12 12.8c-3 0-5.4 2.2-5.4 4.6 0 1.7 1.3 2.8 3 2.8 1 0 1.7-.4 2.4-.4s1.4.4 2.4.4c1.7 0 3-1.1 3-2.8 0-2.4-2.4-4.6-5.4-4.6z',
        masks: 'M9.6 3.5c-2.6 0-4.7.6-5.4 1-.4.2-.6.6-.6 1 .3 4.4 1 7.6 2 9.4.8 1.5 2.3 2.4 4 2.4s3.2-.9 4-2.4c1-1.8 1.7-5 2-9.4 0-.4-.2-.8-.6-1-.7-.4-2.8-1-5.4-1zm-2.2 5c.7 0 1.3.4 1.3.9s-.6.9-1.3.9-1.3-.4-1.3-.9.6-.9 1.3-.9zm4.4 0c.7 0 1.3.4 1.3.9s-.6.9-1.3.9-1.3-.4-1.3-.9.6-.9 1.3-.9zm-3.6 3.9h2.8c-.2.9-.8 1.4-1.4 1.4s-1.2-.5-1.4-1.4zM19 6.6c-.5 0-1 0-1.5.1-.3 3.9-.9 6.8-1.9 8.8.7.5 1.5.8 2.4.8 1.4 0 2.6-.7 3.3-2 .8-1.5 1.4-4.1 1.6-7.6a1 1 0 00-.5-.8c-.6-.3-1.9-.7-3.4-.7z',
        smile: 'M12 2a10 10 0 100 20 10 10 0 000-20zM8.6 8.4a1.4 1.4 0 110 2.8 1.4 1.4 0 010-2.8zm6.8 0a1.4 1.4 0 110 2.8 1.4 1.4 0 010-2.8zM12 18c-2.3 0-4.3-1.4-5.1-3.4a.8.8 0 011.1-1c1 .8 2.4 1.3 4 1.3s3-.5 4-1.3a.8.8 0 011.1 1C16.3 16.6 14.3 18 12 18z',
    },

    // Trazos de contorno (stroke)
    _stroke: {
        starOutline: 'M12 3.6l2.6 5.3 5.8.8-4.2 4.1 1 5.8-5.2-2.7-5.2 2.7 1-5.8L3.6 9.7l5.8-.8z',
        search: 'M11 4a7 7 0 100 14 7 7 0 000-14zM16.5 16.5L21 21',
        close: 'M6 6l12 12M18 6L6 18',
        plus: 'M12 5v14M5 12h14',
        minus: 'M5 12h14',
        check: 'M4.5 12.5l5 5 10-11',
        chevronDown: 'M6 9.5l6 6 6-6',
        chevronRight: 'M9.5 6l6 6-6 6',
        keyboard: 'M3 6.5h18v11H3zM6.5 10h.01M10 10h.01M13.5 10h.01M17 10h.01M6.5 14h11',
        walk: 'M11 21l1.6-5.2-2.1-2.3.9-4.7-2.9 1.8L7 13M12.6 15.8L15 21M14.9 10.9l2.6 1.3M13.5 5.6a1.6 1.6 0 103.2 0 1.6 1.6 0 00-3.2 0z',
        folder: 'M3.5 6.5a1 1 0 011-1h4l2 2.2h8a1 1 0 011 1v9.8a1 1 0 01-1 1h-14a1 1 0 01-1-1z',
        folderOpen: 'M3.5 18.5v-12a1 1 0 011-1h4l2 2.2h8a1 1 0 011 1v1.8M3.5 18.5l2.6-7h15.4l-2.6 7z',
        music: 'M9 18V6.2l10-2v11.6M9 18a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0zM19 15.8a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z',
        cube: 'M12 2.8l8 4.3v9.8l-8 4.3-8-4.3V7.1zM4 7.1l8 4.3 8-4.3M12 11.4V21',
        users: 'M15.5 20v-1.8a3.5 3.5 0 00-3.5-3.5H6.5A3.5 3.5 0 003 18.2V20M9.2 11.2a3.4 3.4 0 100-6.8 3.4 3.4 0 000 6.8zM21 20v-1.8a3.5 3.5 0 00-2.6-3.4M15.6 4.6a3.4 3.4 0 010 6.6',
        clock: 'M12 3.6a8.4 8.4 0 100 16.8 8.4 8.4 0 000-16.8zM12 7.4V12l3 1.8',
        copy: 'M9 9.5a2 2 0 012-2h7a2 2 0 012 2v7a2 2 0 01-2 2h-7a2 2 0 01-2-2zM5.5 15.5A2 2 0 014 13.6V6a2 2 0 012-2h7.5a2 2 0 011.9 1.4',
        trash: 'M4.5 7h15M9.5 7V5.2a1 1 0 011-1h3a1 1 0 011 1V7M6.5 7l.9 12a1 1 0 001 1h7.2a1 1 0 001-1l.9-12M10 11v6M14 11v6',
        sliders: 'M4 8h10M18 8h2M4 16h4M12 16h8M16 5.6v4.8M8 13.6v4.8',
        download: 'M12 3.6v11M7.6 10.2L12 14.6l4.4-4.4M4.5 18.5h15',
        upload: 'M12 14.6v-11M7.6 8L12 3.6 16.4 8M4.5 18.5h15',
        grid: 'M4 4h7v7H4zM13 4h7v7h-7zM4 13h7v7H4zM13 13h7v7h-7z',
        list: 'M8 6.5h12M8 12h12M8 17.5h12M4 6.5h.01M4 12h.01M4 17.5h.01',
        pin: 'M12 21s6.5-6 6.5-10.5a6.5 6.5 0 10-13 0C5.5 15 12 21 12 21zM12 13a2.5 2.5 0 100-5 2.5 2.5 0 000 5z',
        eye: 'M2.5 12S6 6 12 6s9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6zM12 14.6a2.6 2.6 0 100-5.2 2.6 2.6 0 000 5.2z',
        eyeOff: 'M4 4l16 16M9.6 9.7A2.6 2.6 0 0012 14.6c.7 0 1.3-.3 1.8-.7M6.4 6.6C3.9 8.2 2.5 12 2.5 12s3.5 6 9.5 6c1.6 0 3-.4 4.2-1M11 6.1c.3 0 .7-.1 1-.1 6 0 9.5 6 9.5 6s-.8 1.4-2.3 2.9',
        rotate: 'M20 5.5v5h-5M4 18.5v-5h5M19.4 10.5a7.5 7.5 0 00-13.3-2.6M4.6 13.5a7.5 7.5 0 0013.3 2.6',
        arrows: 'M8 4.5L4.5 8 8 11.5M4.5 8H14M16 12.5l3.5 3.5-3.5 3.5M19.5 16H10',
        gamepad: 'M7.5 10v4M5.5 12h4M15 11.2h.01M17.4 13.4h.01M7.6 6.5h8.8a4.6 4.6 0 014.5 3.7l.7 4a3.3 3.3 0 01-5.9 2.6l-.9-1.3H9.2l-.9 1.3a3.3 3.3 0 01-5.9-2.6l.7-4a4.6 4.6 0 014.5-3.7z',
    },

    /** Inyecta el sprite en el documento. Idempotente. */
    mount() {
        if (this._mounted) return;
        this._mounted = true;

        const NS = 'http://www.w3.org/2000/svg';
        const sprite = document.createElementNS(NS, 'svg');
        sprite.setAttribute('aria-hidden', 'true');
        sprite.style.cssText = 'position:absolute;width:0;height:0;overflow:hidden';

        const add = (name, d, stroked) => {
            const symbol = document.createElementNS(NS, 'symbol');
            symbol.id = 'i-' + name;
            symbol.setAttribute('viewBox', '0 0 24 24');
            const path = document.createElementNS(NS, 'path');
            path.setAttribute('d', d);
            if (stroked) {
                path.setAttribute('fill', 'none');
                path.setAttribute('stroke', 'currentColor');
                path.setAttribute('stroke-width', '1.7');
                path.setAttribute('stroke-linecap', 'round');
                path.setAttribute('stroke-linejoin', 'round');
            } else {
                path.setAttribute('fill', 'currentColor');
            }
            symbol.appendChild(path);
            sprite.appendChild(symbol);
        };

        for (const [name, d] of Object.entries(this._fill)) add(name, d, false);
        for (const [name, d] of Object.entries(this._stroke)) add(name, d, true);

        document.body.insertBefore(sprite, document.body.firstChild);
    },

    /**
     * Crea un <svg> que referencia un simbolo del sprite.
     * @param {string} name
     * @param {string} [className]
     * @returns {SVGElement}
     */
    el(name, className) {
        const NS = 'http://www.w3.org/2000/svg';
        const svg = document.createElementNS(NS, 'svg');
        svg.setAttribute('class', 'icon' + (className ? ' ' + className : ''));
        svg.setAttribute('aria-hidden', 'true');
        const use = document.createElementNS(NS, 'use');
        use.setAttribute('href', '#i-' + name);
        svg.appendChild(use);
        return svg;
    },

    /** Reapunta un <svg> existente a otro simbolo (para reutilizar el pool). */
    set(svg, name) {
        const use = svg && svg.firstElementChild;
        if (use) use.setAttribute('href', '#i-' + name);
    },

    has(name) {
        return name in this._fill || name in this._stroke;
    }
};
