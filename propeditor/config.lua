-- ─── Editor de props (propeditor/) ───────────────────────────────────────────
--
-- Ajustes propios del editor. Viven aqui y no en config.lua para que todo lo
-- que hace falta desactivar quepa en un solo directorio: si el bloque de
-- fxmanifest.lua se comenta, este fichero no se carga y nada mas cambia.

Config = Config or {}

Config.PropEditor = {
    -- Puesto a false, el comando no responde y el servidor rechaza guardados.
    -- Los overrides ya guardados se siguen aplicando: para dejar de aplicarlos
    -- hay que borrar propeditor/data/prop_overrides.json o comentar el bloque
    -- de fxmanifest.lua.
    enabled = true,

    -- Comando que abre el editor. Se registra tal cual.
    command = 'propeditor',

    -- ACE que hace falta para abrir y guardar. Con nil puede cualquiera, que es
    -- lo comodo mientras se calibra un pack en un servidor de pruebas. En
    -- produccion conviene poner algo como 'dwkemotes.propeditor'.
    ace = nil,

    -- Como se interpretan WASD/RF al mover el prop.
    --
    --   'camera' - respecto a lo que se ve: W aleja, S acerca, A/D mueven a
    --              izquierda y derecha de la pantalla, R/F suben y bajan. Para
    --              lograrlo hay que traducir ese desplazamiento al espacio del
    --              hueso, que es donde AttachEntityToEntity espera el offset, y
    --              los ejes del hueso se miden solos al enfocarlo (tres frames,
    --              una vez por hueso).
    --   'bone'   - los ejes crudos del hueso, que es como funcionaba antes:
    --              W/S eje Y, A/D eje X, R/F eje Z. Los huesos de la mano estan
    --              girados de cualquier manera, asi que las teclas mueven en
    --              direcciones que no se corresponden con la pantalla.
    --
    -- Girar (Ctrl + las mismas teclas) va en ejes del hueso en los dos modos.
    axisMode = 'camera',

    -- Pasos de ajuste con teclado. El fino es el de siempre; el grueso es el
    -- que se aplica con Shift para llegar rapido a la zona correcta.
    stepFine = 0.005,
    stepCoarse = 0.05,
    stepRotFine = 1.0,
    stepRotCoarse = 10.0,

    -- Limites de la posicion del prop respecto al hueso. Un prop pegado a una
    -- mano nunca necesita mas de medio metro; el tope evita perderlo de vista
    -- por un cero de mas al teclear.
    limitPos = 1.5,

    -- Camara de orbita del editor.
    camDistance = 1.6,   -- distancia inicial al hueso enfocado
    camDistanceMin = 0.35,
    camDistanceMax = 6.0,
}
