# High-Performance GraphQL URL Shortener

Una API para acortar URLs construida con **Ruby on Rails 8.1** y **GraphQL**, desplegada en un VPS de Oracle Cloud.

**API:** [https://lynk.lat/graphql](https://lynk.lat/graphql)
**Frontend:** [https://app.lynk.lat](https://app.lynk.lat)

## Características

- **GraphQL-first:** Todas las operaciones principales van por `/graphql`.
- **Slug alfanumérico:** 6 caracteres aleatorios de `[A-Za-z0-9]` con detección de colisiones.
- **Analytics de clicks:** Registra IP, user agent y país (via Geocoder) de cada visita.
- **Cache con Redis:** Slugs e IPs geocodificadas se cachean para reducir consultas a la DB.
- **Background jobs:** El registro de clicks se procesa de forma asíncrona con ActiveJob.
- **Error monitoring:** Integrado con Rollbar para capturar y reportar errores en producción.
- **CI/CD automático:** GitHub Actions corre los tests y despliega a Oracle VPS al mergear a `main`.

## Stack

| Tecnología | Uso |
|---|---|
| Ruby on Rails 8.1 | Framework principal |
| PostgreSQL | Base de datos |
| Redis | Cache y queue de jobs |
| GraphQL Ruby | API |
| Rollbar | Error monitoring |
| Docker + Docker Compose | Deployment |

## Configuración local

### Con Docker (recomendado)

```bash
git clone https://github.com/Jean612/url_shortener.git
cd url_shortener
cp .env.example .env  # edita con tus valores
docker-compose up
```

### Sin Docker

**Requisitos:** Ruby (ver `.ruby-version`), PostgreSQL, Redis

```bash
git clone https://github.com/Jean612/url_shortener.git
cd url_shortener
bundle install
rails db:setup
rails server
```

### Variables de entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
ROLLBAR_ACCESS_TOKEN=your_token_here
```

En producción, el `docker-compose.yml` inyecta las variables desde el `.env` del servidor.

## Uso de la API

La API está disponible en `https://lynk.lat/graphql`. En desarrollo puedes usar GraphiQL en `http://localhost:3000/graphiql`.

### Crear un link corto

```graphql
mutation {
  createLink(input: { originalUrl: "https://www.example.com" }) {
    link {
      originalUrl
      shortUrl
      slug
    }
    errors
  }
}
```

### Consultar un link por slug

```graphql
query {
  link(slug: "abc123") {
    originalUrl
    shortUrl
    clicksCount
    clicks {
      ipAddress
      country
      createdAt
    }
  }
}
```

### Top links más visitados

```graphql
query {
  topLinks(limit: 5) {
    slug
    originalUrl
    clicksCount
  }
}
```

### Redirección

Visitar `https://lynk.lat/<slug>` redirige al URL original con un `301`.

## Testing

```bash
bundle exec rspec
```

## Linting y seguridad

```bash
bin/rubocop --parallel   # linting
bin/brakeman --no-pager  # seguridad
```

## CI/CD

- **CI:** GitHub Actions corre los tests en cada PR contra PostgreSQL y Redis reales.
- **Deploy:** Al mergear a `main`, se despliega automáticamente al VPS via SSH (`docker-compose up -d --build`).

## Estructura del proyecto

```
app/
├── controllers/
│   ├── graphql_controller.rb      # Endpoint GraphQL
│   └── short_links_controller.rb  # Redirección /:slug
├── graphql/
│   ├── mutations/                 # createLink
│   ├── types/                     # LinkType, ClickType
│   └── url_shortener_schema.rb
├── jobs/
│   └── click_recording_job.rb     # Geocodifica y guarda el click
└── models/
    ├── click.rb
    └── link.rb
config/
└── initializers/
    └── rollbar.rb
```

## Licencia

MIT
