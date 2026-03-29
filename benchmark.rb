require_relative 'config/environment'
require 'benchmark/ips'

slug = 'testslug'
original_url = 'https://example.com'
Link.find_or_create_by!(slug: slug, original_url: original_url)

Benchmark.ips do |x|
  x.report("find_by") do
    Link.find_by(slug: slug)
  end

  x.report("cache.fetch") do
    Rails.cache.fetch("link:#{slug}") do
      Link.find_by(slug: slug)
    end
  end

  x.compare!
end
