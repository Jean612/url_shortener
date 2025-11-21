# URL Shortener API

A simple URL shortener built with Ruby on Rails and GraphQL. This application allows users to create short links and tracks clicks, including basic analytics like IP address and country.

## Features

*   **Shorten URLs**: Convert long URLs into short, easy-to-share links.
*   **GraphQL API**: Full support for creating and querying links via GraphQL.
*   **Click Tracking**: Tracks every click on a shortened link.
*   **Analytics**: Records IP address and attempts to determine the country of origin for each click.

## Prerequisites

*   Ruby (version specified in `.ruby-version`)
*   Bundler
*   A database (SQLite3 by default for development)

## Setup

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/url-shortener.git
    cd url-shortener
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    ```

3.  **Setup the database:**

    ```bash
    rails db:setup
    ```

4.  **Start the server:**

    ```bash
    rails server
    ```

    The application will be available at `http://localhost:3000` (or 3001 depending on configuration).

## Usage

### GraphQL API

The API is available at `/graphql`. You can interact with it using a tool like GraphiQL or Postman.

#### Create a Short Link

**Mutation:**

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

#### Query Link Details

**Query:**

```graphql
query {
  link(slug: "abc123") {
    originalUrl
    clicksCount
    clicks {
      ipAddress
      country
      createdAt
    }
  }
}
```

### Redirection

To visit a shortened link, simply navigate to:

`http://localhost:3001/s/<slug>`

For example: `http://localhost:3001/s/abc123`

## Testing

Run the test suite with:

```bash
bundle exec rspec
```

## Project Structure

*   `app/models`: ActiveRecord models (`Link`, `Click`).
*   `app/controllers`: API controllers (`ShortLinksController`, `GraphqlController`).
*   `app/graphql`: GraphQL schema, types, mutations, and resolvers.

## License

This project is open source and available under the [MIT License](https://opensource.org/licenses/MIT).
