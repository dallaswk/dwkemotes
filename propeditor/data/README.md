# propeditor/data/

Ficheros que escribe el editor de props en caliente. No se editan a mano.

- `prop_overrides.json` — props ajustados con `/propeditor`. El servidor los
  reparte a todos los clientes al conectar y se escriben encima de lo que
  declara la emote. Borrarlo devuelve todas las emotes a los props de su pack.
- `prop_overrides_export.lua` — lo que genera `emoteprops export`: los bloques
  `AnimationOptions` listos para pegar en el `.lua` del pack.
