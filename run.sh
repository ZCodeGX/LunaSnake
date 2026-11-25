#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
LUNA_BIN=${LUNA:-}

if [ -z "$LUNA_BIN" ]; then
    for candidate in "$ROOT/../../Luna/build/luna" "$HOME/Documentos/Luna/build/luna" "$HOME/.local/bin/luna" luna; do
        if [ -x "$candidate" ] || command -v "$candidate" >/dev/null 2>&1; then
            LUNA_BIN=$candidate
            break
        fi
    done
fi

if [ -z "$LUNA_BIN" ]; then
    echo "No encontré el binario de Luna. Compilalo o indicá LUNA=/ruta/a/luna" >&2
    exit 1
fi

cd "$ROOT"
exec "$LUNA_BIN" --no-color main.luna "$@"
