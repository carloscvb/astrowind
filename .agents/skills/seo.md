# SEO

## Configuración base (`src/config.yaml`)

Mínimo obligatorio por proyecto:

```yaml
site:
  name: 'Nombre Sitio'
  site: 'https://dominio.com'        # URL final con https, sin trailing slash
  googleSiteVerificationId: 'abc123' # desde Google Search Console

metadata:
  title:
    default: 'Nombre Sitio'
    template: '%s — Nombre Sitio'    # para páginas internas
  description: 'Descripción 150-160 caracteres. Clara, con keyword principal.'
  openGraph:
    site_name: 'Nombre Sitio'
    images:
      - url: '~/assets/images/og-default.png'  # 1200x628px
        width: 1200
        height: 628
  twitter:
    handle: '@handle'
    cardType: summary_large_image

analytics:
  vendors:
    googleAnalytics:
      id: 'G-XXXXXXXXXX'
```

## Metadata por página

En cada página `.astro`, pasar `metadata` al layout:

```astro
---
import Layout from '~/layouts/PageLayout.astro';

const metadata = {
  title: 'Título página — 50-60 caracteres',
  description: 'Descripción única 150-160 caracteres con keyword.',
  openGraph: {
    images: [{ url: '~/assets/images/og-pagina.png' }],
  },
};
---
<Layout metadata={metadata}>
  ...
</Layout>
```

## OG Image

Tamaño: **1200×628px**. Una por página importante (home, servicios, blog).
Herramienta rápida: Canva con plantilla 1200×628.
Colocar en `src/assets/images/og-*.png`.

## Sitemap

Generado automáticamente por `@astrojs/sitemap`. Verificar en `astro.config.ts`:

```typescript
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://dominio.com', // OBLIGATORIO para sitemap
  integrations: [sitemap()],
});
```

Tras deploy: verificar `https://dominio.com/sitemap-index.xml` existe.
Enviar a Google Search Console.

## robots.txt (`public/robots.txt`)

```
User-agent: *
Allow: /

Sitemap: https://dominio.com/sitemap-index.xml
```

Cambiar el dominio por el del cliente. No bloquear rutas públicas.

## Checklist SEO pre-lanzamiento

- [ ] `site.site` en `config.yaml` apunta al dominio final (no localhost)
- [ ] Todas las páginas tienen `title` y `description` únicos
- [ ] OG image creada y referenciada (1200×628px)
- [ ] Sitemap accesible en `/sitemap-index.xml`
- [ ] Sitemap enviado a Google Search Console
- [ ] `robots.txt` con dominio correcto
- [ ] Google Analytics ID configurado y verificado
- [ ] Google Site Verification añadido
- [ ] No hay páginas con `robots: { index: false }` accidentalmente
- [ ] Lighthouse SEO score ≥ 90
