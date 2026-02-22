# frozen_string_literal: true

# This script is designed to benchmark the performance of the `top_links` query.
# Due to environment restrictions (missing gems), it cannot be executed here.
# It serves as a documentation of the measurement methodology.

if __FILE__ == $0
  begin
    require_relative 'config/environment'
    require 'benchmark'

    puts "Setting up benchmark data..."

    # Create enough data to make the query meaningful
    # Using raw SQL for speed in setup if possible, or FactoryBot if available
    # Here using standard ActiveRecord

    # Create 1000 links with random click counts
    1000.times do |i|
      Link.create!(
        original_url: "https://example.com/#{i}",
        clicks_count: rand(0..10000)
      )
    end

    puts "Data created. Starting benchmark..."

    # Warm up cache if testing cached version
    # UrlShortenerSchema.execute("{ topLinks(limit: 10) { slug clicksCount } }")

    Benchmark.bm(20) do |x|
      x.report("top_links (uncached)") do
        # Simulate clearing cache or disable it
        Rails.cache.clear
        100.times do
          UrlShortenerSchema.execute("{ topLinks(limit: 10) { slug clicksCount } }")
        end
      end

      x.report("top_links (cached)") do
        # First hit populates cache
        UrlShortenerSchema.execute("{ topLinks(limit: 10) { slug clicksCount } }")

        # Subsequent hits use cache
        100.times do
          UrlShortenerSchema.execute("{ topLinks(limit: 10) { slug clicksCount } }")
        end
      end
    end

    puts "Benchmark complete."

  rescue LoadError => e
    puts "Could not load Rails environment: #{e.message}"
    puts "This script is for documentation purposes only."
  rescue => e
    puts "An error occurred: #{e.message}"
  end
end
