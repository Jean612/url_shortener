# 🚀 High-Performance GraphQL URL Shortener

Una API robusta diseñada para acortar URLs con alta eficiencia, utilizando **Ruby on Rails 8.1** y **GraphQL**.

**Demo en vivo:** [https://s.jeanchavez.dev/graphql](https://s.jeanchavez.dev/graphql)

## ⚡ Características Técnicas
- **API-First Design:** Construido enteramente sobre GraphQL.
- **Algoritmo Base62:** Codificación eficiente para generar slugs cortos y únicos.
- **PostgreSQL:** Almacenamiento relacional optimizado.
- **Error Handling:** Gestión robusta de errores (URLs inválidas, no encontradas).

## 📋 Requisitos Previos

*   Ruby (versión especificada en `.ruby-version`)
*   Bundler
*   PostgreSQL

## 🛠️ Configuración

1.  **Clonar el repositorio:**

    ```bash
    git clone https://github.com/yourusername/url-shortener.git
    cd url-shortener
    ```

2.  **Instalar dependencias:**

    ```bash
    bundle install
    ```

3.  **Configurar la base de datos:**

    Asegúrate de que el servicio de PostgreSQL esté en ejecución.

    La aplicación utiliza `config/database.yml` para la configuración de la base de datos. Por defecto, busca un usuario llamado `url_shortener` sin contraseña en desarrollo. Puedes actualizar `config/database.yml` o usar variables de entorno para adaptarlo a tu configuración local.

4.  **Preparar la base de datos:**

    Crear la base de datos y ejecutar migraciones:

    ```bash
    rails db:setup
    ```

5.  **Iniciar el servidor:**

    ```bash
    rails server
    ```

    La aplicación estará disponible en `http://localhost:3000` (o 3001 dependiendo de la configuración).

## 🔌 Uso de la API

La API es accesible en `/graphql` (o en el link del demo). Puedes interactuar con ella utilizando herramientas como GraphiQL, Postman o cURL.

### 1. Crear un Link Corto (Mutation)

Para acortar una URL, utiliza la mutación `createLink`.

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

### 2. Consultar un Link por Slug (Query)

Para obtener los detalles de un link específico, incluyendo su URL original y estadísticas de clics, usa la query `link` proporcionando el `slug`.

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

### 3. Consultar Top Links (Query)

Para obtener los links más visitados, utiliza la query `topLinks`. Puedes limitar la cantidad de resultados.

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

Para visitar un link acortado, simplemente navega a:

`https://s.jeanchavez.dev/<slug>` (en producción)
o
`http://localhost:3000/<slug>` (en local)

Ejemplo: `https://s.jeanchavez.dev/abc123`

## 🧪 Testing

Ejecuta la suite de pruebas con:

```bash
bundle exec rspec
```

## 📂 Estructura del Proyecto

*   `app/models`: Modelos ActiveRecord (`Link`, `Click`).
*   `app/controllers`: Controladores de la API (`ShortLinksController`, `GraphqlController`).
*   `app/graphql`: Esquema GraphQL, tipos, mutaciones y resolvers.

## 📄 Licencia

Este proyecto es open source y está disponible bajo la [Licencia MIT](https://opensource.org/licenses/MIT).
