require_relative 'config/environment'
require 'benchmark'

link = Link.first || Link.create!(original_url: "https://example.com")

puts "Benchmarking ClickRecordingJob..."

# Monkey patch Geocoder to simulate a slow API call
module Geocoder
  class << self
    alias_method :original_search, :search
    def search(*args)
      sleep 2 # Simulate 2 seconds latency
      original_search(*args)
    end
  end
end

time = Benchmark.measure do
  10.times do |i|
    ip = "8.8.4.#{i}"
    # Clear cache to ensure Geocoder runs
    Rails.cache.delete("ip_country:#{ip}")
    ClickRecordingJob.perform_now(link_id: link.id, ip_address: ip, user_agent: "BenchmarkAgent")
  end
end

puts "Time taken for 10 slow geocode jobs: #{time.real} seconds"
