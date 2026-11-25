# Luna Snake

Versión de **Snake** escrita en [Luna](https://github.com/ZCodeGX/Luna), con la misma estructura modular que Luna Naval: módulos en `juego/`, CLI con `--demo --seed`, estadísticas persistentes en JSON, consola de sistema con `os.run` y limpieza de pantalla con `os.system`.

**Estado:** funcional · **Luna:** 0.7.6+ con `os.run`/`os.system` · **Licencia de Luna:** GPL-3.0

## Qué hace

- Tablero 12×8 con serpiente que crece al comer (`*`).
- Movimiento por turnos con `w`/`a`/`s`/`d`; no se permite invertir la dirección actual.
- Derrota al chocar contra el borde o contra el propio cuerpo.
- IA simple para el modo `--demo`, reproducible con `--seed`.
- Estadísticas en `datos/estadisticas.json`: partidas, mejor puntuación y comidas totales.
- Menú interactivo, ayuda, consola con `os.run` y limpieza de consola con `clear`/`cls`.

## Requisitos

Necesitás el compilador/runtime de Luna con `os.run` y `os.system` (commit `e1b6466` o posterior). `run.sh` busca el binario en `../../Luna/build/luna` respecto del juego, en `$HOME/Documentos/Luna/build/luna`, en `PATH`, o podés indicarlo con `LUNA=/ruta/a/luna`.

```bash
git clone https://github.com/ZCodeGX/Luna.git
cd Luna
./luna.py build
```

## Uso

```bash
./run.sh                       # menú interactivo
./run.sh --demo                # partida automática
./run.sh --demo --seed 42      # misma partida siempre
./run.sh --help
```

Ejecutá siempre desde la raíz del proyecto: las estadísticas se guardan en `datos/`. En el menú, la opción `5` abre una consola de prueba con `os.run`.

### Salida del modo demo (semilla 42, extracto)

```text
 Modo demostración (semilla 42)
----------------------------------------------------
FIN: te mordiste | comidas: 14 | pasos: 116
----------------------------------------------------
```

## Cómo jugar

Escribí `w` (arriba), `a` (izquierda), `s` (abajo) o `d` (derecha) y presioná Enter. La serpiente avanza una casilla por entrada. `O` es la cabeza, `o` el cuerpo, `*` la comida y `.` una casilla libre. `salir` vuelve al menú.

## Pruebas

```bash
./tests/run.sh
```

Ejecuta 19 comprobaciones (`tests/smoke.luna`) y una partida demo determinista. GitHub Actions hace lo mismo compilando Luna desde cero.

## Estructura

| Archivo | Qué muestra de Luna |
| --- | --- |
| `main.luna` | entrada del programa, `argv`, CLI y menú |
| `juego/config.luna` | constantes y símbolos del tablero |
| `juego/serpiente.luna` | tablas, listas mutables y colisiones |
| `juego/tablero.luna` | comida aleatoria y búsqueda de casilla libre |
| `juego/ia.luna` | direcciones barajadas y distancia a la comida |
| `juego/render.luna` | construcción de strings y tableros |
| `juego/estadisticas.luna` | `io` + `json`, `try`/`catch` y persistencia |
| `juego/partida.luna` | bucle de turnos, `input` y orquestación |
| `juego/shell.luna` | `os.run`/`os.system` y limpieza de consola |
| `tests/smoke.luna` | pruebas sin intervención del usuario |

## Detalles del lenguaje que se ponen a prueba

- Importaciones con paquetes (`import juego`, `import juego.serpiente`) y exports `pub`.
- Funciones integradas sin `import`: `print`, `len`, `type`, `str`, `int`, `float`, `bool`, `input`.
- `let`, tablas con claves literales, listas, indexación y asignación compuesta.
- `if`/`else` anidados, `while`, `for ... in` y `try`/`catch`.
- Random determinista con `math.seed`, `math.randint` y `math.shuffle`.
- Serialización `json.encode`/`json.decode` y archivos con `io.read`, `io.write` e `io.ensure_dir`.
- Ejecución de procesos con `os.run` y `os.system` para la consola y la limpieza de pantalla.
- Nota: las cadenas no se concatenan con `+`; se usa `string.concat`. Las decisiones de tres o más ramas se escriben con `else:` + `if` anidado.
