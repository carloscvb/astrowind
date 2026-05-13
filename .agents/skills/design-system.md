# Sistema de Diseño

## Tokens de color (por proyecto)

Editar en `src/components/CustomStyles.astro`:

```css
:root {
  --aw-color-primary: rgb(1 97 239);    /* color principal del cliente */
  --aw-color-secondary: rgb(1 84 207); /* variante secundaria */
  --aw-color-accent: rgb(109 40 217);  /* acento/CTA */

  --aw-color-text-default: rgb(16 16 16);
  --aw-color-text-muted: rgb(100 100 100);
  --aw-color-bg-page: rgb(255 255 255);
}
.dark {
  --aw-color-primary: rgb(1 97 239);
  --aw-color-text-default: rgb(229 229 229);
  --aw-color-text-muted: rgb(160 160 160);
  --aw-color-bg-page: rgb(3 6 32);
}
```

Usar siempre tokens semánticos (`bg-primary`, `text-default`) no colores directos de Tailwind (`bg-blue-600`) para mantener coherencia en modo oscuro.

## Tipografía

Cambiar fuente en `CustomStyles.astro`:

```css
:root {
  --aw-font-sans: 'Inter Variable';   /* cuerpo */
  --aw-font-serif: var(--font-serif); /* títulos opcionales */
  --aw-font-heading: var(--aw-font-sans);
}
```

Instalar fuente: `npm install @fontsource-variable/inter`
Importar en `CustomStyles.astro`: `import '@fontsource-variable/inter';`

Fuentes recomendadas (variables, rendimiento óptimo):
- Sans: Inter, Plus Jakarta Sans, DM Sans, Geist
- Serif: Lora, Playfair Display

## Escala tipográfica Tailwind

Usar clases estándar de Tailwind para consistencia:

| Uso | Clase |
|-----|-------|
| H1 hero | `text-4xl md:text-5xl xl:text-6xl` |
| H2 sección | `text-3xl md:text-4xl` |
| H3 | `text-2xl md:text-3xl` |
| Cuerpo | `text-base` o `text-lg` |
| Muted | `text-sm text-muted` |

## Espaciado

Secciones: `py-16 md:py-20` (usar `WidgetWrapper`, ya lo aplica).
Contenedor: `max-w-7xl mx-auto px-4 sm:px-6` (usar `WidgetWrapper`).
No reinventar — usar `WidgetWrapper` para todas las secciones.

## Accesibilidad mínima

- Contraste: ratio mínimo 4.5:1 para texto normal, 3:1 para texto grande
- Imágenes: siempre `alt` descriptivo (no `alt=""` salvo decorativas)
- Botones sin texto: incluir `aria-label`
- Focus visible: no eliminar `outline` en CSS
- Orden lógico de headings: H1 → H2 → H3, sin saltar niveles

## Animaciones

Usar la variante `intersect` para scroll animations:

```html
<div class="intersect-once motion-safe:opacity-0 motion-safe:intersect:animate-fade">
  contenido
</div>
```

`motion-safe:` respeta la preferencia `prefers-reduced-motion` del usuario.
