/**
 * dwkemotes - Puente NUI
 * -----------------------------------------------------------------------------
 * Envoltorio fino sobre los callbacks del recurso. Todas las llamadas devuelven
 * una promesa que nunca rechaza: si el recurso no responde, la interfaz sigue
 * viva en lugar de quedarse a medias.
 */
const _resourceName = (typeof GetParentResourceName === 'function')
    ? GetParentResourceName()
    : 'dwkemotes';

const NUI = {
    /** Fuera del juego (abrir el html en un navegador) no hay backend al que llamar. */
    _standalone: typeof GetParentResourceName !== 'function',

    callback(name, data = {}) {
        if (this._standalone) return Promise.resolve({});
        return fetch(`https://${_resourceName}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data)
        })
            .then(resp => (resp.ok ? resp.json() : {}))
            .catch(() => ({}));
    },

    closeMenu()                                      { return this.callback('closeMenu'); },
    playEmote(name, emoteType, textureVariation)     { return this.callback('playEmote', { name, emoteType, textureVariation }); },
    playSharedEmote(name)                            { return this.callback('playSharedEmote', { name }); },
    groupEmote(name)                                 { return this.callback('groupEmote', { name }); },
    placeEmote(name)                                 { return this.callback('placeEmote', { name }); },
    assignKeybind(slot, emoteName, emoteType, label) { return this.callback('assignKeybind', { slot, emoteName, emoteType, label }); },
    clearKeybind(slot)                               { return this.callback('clearKeybind', { slot }); },
    setWalkStyle(name)                               { return this.callback('setWalkStyle', { name }); },
    resetWalkStyle()                                 { return this.callback('setWalkStyle', { reset: true }); },
    setExpression(name)                              { return this.callback('setExpression', { name }); },
    resetExpression()                                { return this.callback('setExpression', { reset: true }); },
    showEmoji(name)                                  { return this.callback('showEmoji', { name }); },
    previewEmote(name, emoteType)                    { return this.callback('previewEmote', { name, emoteType }); },
    stopPreview()                                    { return this.callback('stopPreview'); },
    cancelEmote()                                    { return this.callback('cancelEmote'); },
    searchFocus()                                    { return this.callback('searchFocus'); },
    searchBlur()                                     { return this.callback('searchBlur'); },
    clearUsage()                                     { return this.callback('clearUsage'); },
    refreshUsage()                                   { return this.callback('refreshUsage'); },
};
