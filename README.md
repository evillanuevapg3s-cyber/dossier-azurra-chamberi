# Dossier de Calidad — AZURRA Chamberí (Miraflores, Lima)

Repositorio del **Dossier de Calidad** de los sistemas de protección contra incendios
e instalaciones mecánicas del Edificio Multifamiliar Chamberí.

| Dato | Detalle |
|------|---------|
| **N° de contrato** | ANX-989-26 |
| **Propietario** | INVERSIONES Y CONSTRUCCIONES G.R. S.A.C. |
| **Proyecto** | EDIFICIO MULTIFAMILIAR CHAMBERÍ — "AZURRA CHAMBERÍ" |
| **Dirección** | Calle Chamberí N° 130-136, Urb. Santa Cruz, Miraflores — Lima |
| **Ejecutor** | SUN FIRE SAC |
| **Cliente / contratante** | AZZURRA (Blu Roccia SAC) |

## Cómo visualizar el dossier
- **En línea:** abre la página publicada (GitHub Pages) desde el enlace del repositorio.
- **Sin internet:** descarga el repositorio (**Code → Download ZIP**), descomprímelo y
  abre **`index.html`** con doble clic (Chrome o Edge).

Desde la página puedes navegar por las secciones, ver cada documento y descargarlo,
por sección o todo el dossier en un ZIP.

## Estructura
- `index.html` — visor del dossier (índice navegable, búsqueda, ver/descargar).
- `00.` a `11.` — secciones (tomos) del dossier.
- `_dossier_web/` — recursos del visor (índice, logos, fondos) y el regenerador del índice.

## Alcance de los sistemas
1. **ACI** — Agua Contra Incendios (red, montantes, rociadores, cuarto de bombas)
2. **DACI / DyA** — Detección y Alarma (panel Bosch B9512G, dispositivos Wizmart)
3. **IIMM** — Instalaciones Mecánicas (extracción de monóxido, vestíbulos, presurización de escaleras)
4. **Tableros Eléctricos** de los sistemas de bombeo y mecánicos
5. **Puertas Corta Fuego**

## Actualizar el índice tras agregar documentos
El índice del visor es una "foto" del contenido. Tras agregar o quitar archivos,
ejecuta `_dossier_web/Actualizar-Indice.ps1` (clic derecho → Ejecutar con PowerShell)
y vuelve a hacer commit. Ver `_dossier_web/LEEME.txt` para más detalle.

## Logo del cliente
Coloca el logo de AZZURRA en `_dossier_web/logo-cliente.png` (PNG con fondo transparente).
Mientras no exista, la página muestra un logo de texto provisional.

---
Visualización referencial. La validez oficial corresponde a los documentos firmados del Dossier.
