# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **GraphQL-first URL shortening service** built with Ruby on Rails 8.1. The application:
- Uses PostgreSQL for data persistence
- Implements a Base62-like slug generation algorithm (6-character alphanumeric)
- Tracks click analytics (IP, user agent, country via Geocoder)
- Has both GraphQL API (`/graphql`) and REST redirect endpoints (`/:slug`)

## Development Commands

### Setup
```bash
bundle install
rails db:setup                # Creates database and runs migrations
```

### Running the Application
```bash
rails server                  # Starts on localhost:3000 (or 3001)
```

Access GraphiQL playground in development: `http://localhost:3000/graphiql`

### Testing
```bash
bundle exec rspec             # Run all tests
bundle exec rspec spec/models/link_spec.rb              # Run specific test file
bundle exec rspec spec/models/link_spec.rb:10           # Run specific test at line 10
```

### Linting & Security
```bash
bin/rubocop --parallel        # Lint with RuboCop (Rails Omakase style)
bin/rubocop -a                # Auto-fix linting issues
bin/brakeman --no-pager       # Security vulnerability scan
```

### Database
```bash
rails db:migrate              # Run pending migrations
rails db:rollback             # Rollback last migration
rails db:test:prepare         # Prepare test database
```

### Docker
```bash
docker-compose up             # Start all services (web, postgres, redis)
docker-compose down           # Stop all services
```

## Architecture

### GraphQL Schema Design

The application is GraphQL-first. All primary operations go through `/graphql`:

**Mutations:**
- `createLink(originalUrl: String!)` - Creates a shortened link, returns `link` and `errors`

**Queries:**
- `link(slug: String!)` - Fetches a link by slug, including clicks data
- `topLinks(limit: Int)` - Returns most-clicked links (default limit: 10)

**Types:**
- `LinkType` - Exposes `originalUrl`, `shortUrl`, `slug`, `clicksCount`, `clicks`
- `ClickType` - Exposes `ipAddress`, `userAgent`, `country`, `createdAt`

Schema location: `app/graphql/url_shortener_schema.rb`

### Models & Data Flow

**Link Model** (`app/models/link.rb`):
- Auto-generates unique 6-character alphanumeric slug on creation
- Uses `SecureRandom.alphanumeric(6)` with collision detection loop
- Validates URL format with `URI.regexp(%w[http https])`
- Computes `short_url` dynamically using `RENDER_EXTERNAL_HOSTNAME` env var or default host
- Has counter cache `clicks_count` for performance

**Click Model** (`app/models/click.rb`):
- Uses `counter_cache: true` on `belongs_to :link` to auto-increment `clicks_count`
- Records analytics: IP, user agent, country (via Geocoder gem)

**Click Recording Flow:**
1. User visits `/:slug` → `ShortLinksController#show`
2. Controller calls `record_click(link)` synchronously (MVP approach, not async)
3. Geocoder attempts IP→Country lookup (fails gracefully on errors/rate limits)
4. Click created, counter cache updated
5. 301 redirect to original URL

### Routing Structure

```ruby
POST /graphql               # GraphQL endpoint (main API)
GET  /graphiql              # GraphiQL playground (development only)
GET  /:slug                 # Redirect endpoint (ShortLinksController#show)
GET  /up                    # Health check endpoint
```

**Important:** The `/:slug` route is a catch-all at root level. Any path not matching other routes will hit `ShortLinksController#show`.

### Configuration Notes

**CORS:** Configured in `config/initializers/cors.rb` - allows all origins in development.

**Database:** Uses PostgreSQL with username `url_shortener` (no password in dev/test). Production expects `URL_SHORTENER_DATABASE_PASSWORD` env var.

**Host Configuration:**
- Local: defaults to `localhost:3000`
- Production: reads `RENDER_EXTERNAL_HOSTNAME` env var for `short_url` generation
- Set in `config/application.rb` via `default_url_options`

### Testing Strategy

Tests use RSpec with FactoryBot for fixtures:
- Model specs: `spec/models/`
- Request specs: `spec/requests/`
- GraphQL specs: `spec/graphql/`
- Factories: `spec/factories/`

CI runs on GitHub Actions (`.github/workflows/ci.yml`) with PostgreSQL and Redis services.

## Key Implementation Details

**Slug Generation:**
- 6 characters from `[A-Za-z0-9]` (62 possible characters)
- Collision detection via loop with `Link.exists?(slug:)`
- Set in `before_validation :generate_slug, on: :create`

**Click Analytics:**
- Geocoder gem used for IP→Country lookup (may be slow/rate-limited)
- Synchronous recording in `ShortLinksController#record_click`
- Errors logged but don't block redirect

**GraphQL Error Handling:**
- Mutations return `{ link:, errors: [] }` pattern
- Validation errors from ActiveRecord exposed via `errors.full_messages`

## Development Workflow

This project follows Rails conventions:
- Uses `frozen_string_literal: true` pragma
- Follows Rails Omakase RuboCop style
- YARD documentation style for methods
- Counter caches for performance optimization
