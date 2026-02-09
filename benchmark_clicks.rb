# frozen_string_literal: true

# This script demonstrates the memory usage issue of loading all clicks.
# Since the environment prevents execution, this is a theoretical benchmark.

require 'benchmark'
require 'memory_profiler'

def run_benchmark
  # Setup: Create a Link with 10,000 clicks
  link = Link.create!(original_url: "https://example.com/benchmark")
  10_000.times do
    Click.create!(link: link, ip_address: "127.0.0.1")
  end

  query_string = <<~GQL
    query {
      link(slug: "#{link.slug}") {
        clicks {
          id
        }
      }
    }
  GQL

  puts "Running query with 10,000 clicks (unpaginated)..."

  report = MemoryProfiler.report do
    result = UrlShortenerSchema.execute(query_string)
  end

  puts "Total allocated: #{report.total_allocated_memsize} bytes"
  puts "Total retained:  #{report.total_retained_memsize} bytes"

  # Expected Result (Unoptimized):
  # Large allocation due to loading 10,000 Click objects into memory via dataloader.

  # Expected Result (Optimized with pagination):
  # Minimal allocation if query uses pagination (e.g., first: 10).
  # Even without arguments, if default limit applies, allocation is small.
  # However, changing to connection_type requires changing the query to use edges/nodes.
end

if __FILE__ == $0
  begin
    require_relative 'config/environment'
    run_benchmark
  rescue LoadError => e
    puts "Could not load Rails environment: #{e.message}"
    puts "This benchmark is for demonstration purposes only."
  end
end
