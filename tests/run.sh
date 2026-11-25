#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
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
echo "== Pruebas unitarias =="
LUNA_PATH="$ROOT" "$LUNA_BIN" --no-color tests/smoke.luna

echo "== Demo determinista =="
primera=$("$LUNA_BIN" --no-color main.luna --demo --seed 42)
printf '%s\n' "$primera" | grep -Eq 'FIN:'
segunda=$("$LUNA_BIN" --no-color main.luna --demo --seed 42)
if [ "$primera" != "$segunda" ]; then
    echo "La demo no es reproducible con la misma semilla" >&2
    exit 1
fi
echo "ok   demo reproducible"

echo "Listo: todas las pruebas pasaron"
