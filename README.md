# 🚀 High-Performance GraphQL URL Shortener

A robust API designed to shorten URLs with high efficiency, built using **Ruby on Rails 7** and **GraphQL**.

**Live Demo:** [https://url-shortener-u7yc.onrender.com/graphql](https://url-shortener-u7yc.onrender.com/graphql)

## ⚡ Technical Features

- **API-First Design:** Built entirely on GraphQL.
- **Base62 Algorithm:** Efficient encoding for generating short and unique slugs.
- **PostgreSQL:** Optimized relational storage.
- **Click Tracking:** Tracks clicks, capturing IP address, user agent, and country (via Geocoder).
- **Error Handling:** Robust error management (invalid URLs, not found).

## 📋 Prerequisites

Ensure you have the following installed on your system:

*   **Ruby** (version specified in `.ruby-version`, e.g., 3.2.0)
*   **Bundler** (`gem install bundler`)
*   **PostgreSQL** (running locally or accessible via network)

## 🛠️ Setup & Installation

Follow these steps to set up the project locally:

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/url-shortener.git
    cd url-shortener
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    ```

3.  **Configure the Database:**

    Make sure your PostgreSQL service is running.

    The application uses `config/database.yml` for database configuration. By default, it expects a user named `url_shortener` with no password in the development environment. You can update `config/database.yml` or use environment variables to match your local setup.

4.  **Prepare the Database:**

    Create the database and run migrations:

    ```bash
    rails db:setup
    ```

5.  **Start the Server:**

    ```bash
    rails server
    ```

    The application will be available at `http://localhost:3000`.

## 🔌 API Usage

The API is accessible at `/graphql`. You can interact with it using tools like GraphiQL (enabled in development), Postman, or cURL.

### 1. Create a Short Link (Mutation)

To shorten a URL, use the `createLink` mutation.

**Request:**
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

**Response:**
```json
{
  "data": {
    "createLink": {
      "link": {
        "originalUrl": "https://www.example.com",
        "shortUrl": "http://localhost:3000/s/abc123",
        "slug": "abc123"
      },
      "errors": []
    }
  }
}
```

### 2. Query a Link by Slug

To get details of a specific link, including its original URL and click statistics, use the `link` query with the `slug`.

**Request:**
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

### 3. Query Top Links

To get the most visited links, use the `topLinks` query. You can limit the number of results.

**Request:**
```graphql
query {
  topLinks(limit: 5) {
    slug
    originalUrl
    clicksCount
  }
}
```

### Redirection

To visit a shortened link, simply navigate to the path `/s/<slug>`.

**Example:** `http://localhost:3000/s/abc123`

This will record a click (analytics) and redirect you to the original URL.

## 🧪 Testing

The project uses RSpec for testing. Run the test suite with:

```bash
bundle exec rspec
```

## 📂 Project Structure

*   `app/models`: ActiveRecord Models (`Link`, `Click`).
*   `app/controllers`: API Controllers (`ShortLinksController`, `GraphqlController`).
*   `app/graphql`: GraphQL Schema, Types, Mutations, and Resolvers.
*   `app/jobs`: Background jobs.
*   `app/mailers`: Email mailers.

## 📄 License

This project is open source and available under the [MIT License](https://opensource.org/licenses/MIT).
