# Workflow: Plantilla → Proyectos

## Estructura de repos

```
arthelokyo/astrowind        ← fuente oficial (upstream)
        ↓
carloscvb/astrowind         ← esta plantilla (LIMPIA, sin contenido de cliente)
        ↓
carloscvb/landing-cliente-x ← proyecto real
carloscvb/landing-cliente-y ← proyecto real
```

**Regla:** Esta plantilla nunca lleva logos, textos ni imágenes de cliente.

---

## 1. Crear proyecto nuevo

**Con script (recomendado):** desde el directorio de la plantilla:

```powershell
.\scripts\nuevo-proyecto.ps1 -nombre "landing-cliente-x" -repo "carloscvb/landing-cliente-x"
```

El script clona la plantilla, configura remotes, instala deps y hace el push inicial.

**Manual:**

```bash
git clone https://github.com/carloscvb/astrowind.git nombre-proyecto
cd nombre-proyecto
git remote set-url origin https://github.com/carloscvb/nombre-proyecto.git
git remote add upstream https://github.com/carloscvb/astrowind.git
git push -u origin main
```

---

## 2. Setup inicial del proyecto (en orden)

### Node.js >= 22.12.0 requerido

```bash
npm install
```

### Archivos a editar obligatoriamente

| Archivo | Qué cambiar |
|---------|-------------|
| `src/config.yaml` | nombre, URL, SEO, GA ID, idioma |
| `src/navigation.ts` | menú y enlaces |
| `src/components/CustomStyles.astro` | colores y fuentes del cliente |
| `src/pages/index.astro` | contenido homepage |
| `src/assets/images/` | imágenes del proyecto |
| `src/assets/favicons/` | favicon del cliente |
| `public/robots.txt` | ajustar si es necesario |

### config.yaml — mínimo a cambiar

```yaml
site:
  name: 'Nombre Cliente'
  site: 'https://dominio-cliente.com'

metadata:
  title:
    default: 'Nombre Cliente'
    template: '%s — Nombre Cliente'
  description: 'Descripción SEO del sitio'
  openGraph:
    site_name: 'Nombre Cliente'
  twitter:
    handle: '@handle'

analytics:
  vendors:
    googleAnalytics:
      id: 'G-XXXXXXXXXX'  # o null si no aplica

apps:
  blog:
    isEnabled: false  # desactivar si no hay blog
```

### Personalización de estilos (Tailwind v4 — CSS-first)

- **Colores/fuentes:** `src/components/CustomStyles.astro`
- **Tokens Tailwind:** `src/assets/styles/tailwind.css`

---

## 3. Verificación antes de deploy

```bash
npm run check    # astro check + ESLint + Prettier
npm run build    # build de producción
npm run preview  # revisar en browser
```

Checklist visual:
- [ ] Homepage carga correcta
- [ ] Dark mode funciona
- [ ] Menú mobile funciona
- [ ] Meta tags correctos (ver source)
- [ ] OG image configurada

---

## 4. Deploy a Vercel

Conectar el repo del proyecto (no la plantilla) en Vercel.
Framework preset: **Astro**. Sin configuración extra.

---

## 5. Actualizar plantilla desde upstream

Cuando `arthelokyo/astrowind` lanza updates:

```bash
# En carloscvb/astrowind (esta plantilla)
git fetch upstream
git merge upstream/main
npm install
npm run check
git push origin main
```

---

## 6. Traer updates de plantilla a un proyecto existente

**Con script (recomendado):** desde la raíz del proyecto cliente:

```powershell
.\scripts\actualizar-desde-plantilla.ps1
```

El script verifica que no hay cambios sin commitear, muestra los commits nuevos, hace el merge, reinstala deps y corre el check.

**Manual:**

```bash
git fetch upstream
git merge upstream/main
npm install
npm run check
```

Si hay conflictos:
- **Priorizar TUS cambios:** `config.yaml`, `navigation.ts`, `index.astro`
- **Priorizar plantilla:** componentes, utils, dependencias
