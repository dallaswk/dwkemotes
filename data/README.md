# data/

Ficheros que escribe el recurso en caliente. No se editan a mano.

- `sync_offsets.json` — offsets de las shared emotes ajustados con `/emoteoffset`.
  Los reparte el servidor a todos los clientes al conectar y se aplican encima
  de lo que declara la animacion. Ver `server/OffsetEditor.lua`.
- `*.bak` — copias de seguridad que deja `emoteoffsets apply` antes de reescribir
  un pack de `custom_emotes/`.
