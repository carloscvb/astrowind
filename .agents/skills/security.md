# Seguridad

## Headers HTTP (`public/_headers`)

Aplican en Vercel y Netlify. Ya incluidos headers seguros base. Para cada proyecto:

1. Descomentar la línea CSP
2. Añadir dominios de terceros que use el cliente (analytics, CRM, widgets)

```
# Ejemplo CSP con Google Analytics + HubSpot
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' https://www.googletagmanager.com https://js.hs-scripts.com; img-src 'self' data: https:; style-src 'self' 'unsafe-inline'; connect-src 'self' https://www.google-analytics.com;
```

Terceros comunes y sus dominios necesarios:
- **Google Analytics:** `https://www.googletagmanager.com https://www.google-analytics.com`
- **HubSpot:** `https://js.hs-scripts.com https://api.hubspot.com`
- **Calendly:** `https://assets.calendly.com`
- **Hotjar:** `https://static.hotjar.com https://script.hotjar.com`
- **Google Maps:** `https://maps.googleapis.com https://maps.gstatic.com`

## Variables de entorno

Nunca exponer secrets al cliente. En Astro:

```typescript
// BIEN: solo disponible en servidor/build
const secret = import.meta.env.SECRET_KEY;

// MAL: expuesto al navegador
const secret = import.meta.env.PUBLIC_SECRET_KEY; // PUBLIC_ = expuesto
```

Regla: `PUBLIC_` solo para valores que pueden ser públicos (GA ID, URLs de API públicas).

## HTML crudo (`set:html`)

Evitar `set:html` con contenido de usuario. Solo usar con contenido controlado:

```astro
<!-- BIEN: contenido propio -->
<div set:html={markdownContent} />

<!-- MAL: contenido de usuario sin sanitizar -->
<div set:html={userInput} />
```

## Imágenes remotas

Dominios permitidos en `astro.config.ts`. Solo añadir los necesarios:

```typescript
image: {
  domains: ['cdn.pixabay.com', 'images.unsplash.com'], // no añadir '*'
}
```

## Checklist de seguridad pre-deploy

- [ ] `npm audit` sin vulnerabilidades críticas o altas
- [ ] Variables de entorno correctas en Vercel (no hardcodeadas en código)
- [ ] CSP configurado en `public/_headers`
- [ ] No hay `console.log` con datos sensibles
- [ ] Formularios de contacto con rate limiting (si hay endpoint API)
