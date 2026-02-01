# URL Shortener API

A robust, GraphQL-first URL shortening service built with Ruby on Rails. It provides high-performance link shortening, redirection, and click tracking analytics.

## 🚀 Features

*   **GraphQL API**: Full-featured API for creating and querying short links.
*   **Base62 Slug Generation**: Efficient, short, and unique URL slugs (e.g., `abc123`).
*   **Analytics**: Tracks clicks, IP addresses, user agents, and geolocation (Country).
*   **PostgreSQL**: Reliable relational data storage.
*   **Docker Ready**: Includes Docker Compose configuration for easy deployment.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

*   **Ruby**: Version specified in `.ruby-version`
*   **PostgreSQL**: Database server
*   **Bundler**: `gem install bundler`

## 🛠️ Setup & Installation

1.  **Clone the repository**

    ```bash
    git clone https://github.com/yourusername/url-shortener.git
    cd url-shortener
    ```

2.  **Install dependencies**

    ```bash
    bundle install
    ```

3.  **Database Setup**

    Ensure your PostgreSQL service is running. The default configuration in `config/database.yml` expects a user named `url_shortener` (configurable).

    ```bash
    # Create the database and run migrations
    rails db:setup
    ```

4.  **Start the Server**

    ```bash
    rails server
    ```

    The API will be available at `http://localhost:3000`.

## ⚙️ Configuration

The application uses standard Rails configuration and environment variables.

*   **Database**: Configured in `config/database.yml`.
*   **Host Name**: Set `RENDER_EXTERNAL_HOSTNAME` env var in production to generate correct short URLs. Locally it defaults to `localhost:3000`.

## 🔌 Usage

The application exposes a GraphQL endpoint at `/graphql`.

### GraphiQL

In development, you can access the GraphiQL playground at:
`http://localhost:3000/graphiql`

### API Examples

#### 1. Shorten a URL (Mutation)

**Request:**

```graphql
mutation {
  createLink(input: { originalUrl: "https://www.example.com" }) {
    link {
      slug
      shortUrl
      originalUrl
    }
    errors
  }
}
```

**Response:**

```json
{
  "data": {
    "createLink": {
      "link": {
        "slug": "Ab3d9X",
        "shortUrl": "http://localhost:3000/s/Ab3d9X",
        "originalUrl": "https://www.example.com"
      },
      "errors": []
    }
  }
}
```

#### 2. Get Link Details (Query)

**Request:**

```graphql
query {
  link(slug: "Ab3d9X") {
    originalUrl
    clicksCount
    clicks {
      country
      createdAt
    }
  }
}
```

#### 3. Top Links (Query)

Fetch the most visited links.

```graphql
query {
  topLinks(limit: 5) {
    slug
    clicksCount
  }
}
```

#### 4. Redirection

Visit the short URL to be redirected to the original URL:

`http://localhost:3000/s/Ab3d9X`

## 🧪 Testing

This project uses RSpec for testing.

```bash
# Run all tests
bundle exec rspec

# Run specific test
bundle exec rspec spec/models/link_spec.rb
```

## 📂 Project Structure

*   `app/models`: ActiveRecord models (`Link`, `Click`) containing business logic.
*   `app/graphql`: GraphQL schema, types, mutations, and resolvers.
*   `app/controllers`: API controllers (`GraphqlController`, `ShortLinksController`).
*   `spec`: RSpec tests mirroring the app structure.

## 📄 License

This project is open source and available under the [MIT License](https://opensource.org/licenses/MIT).
