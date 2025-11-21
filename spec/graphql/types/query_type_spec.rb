require 'rails_helper'

module Types
  RSpec.describe QueryType, type: :request do
    describe 'link' do
      let!(:link) { create(:link, original_url: 'https://example.com') }

      it 'returns the link by slug' do
        post '/graphql', params: { query: <<~GQL
          query {
            link(slug: "#{link.slug}") {
              originalUrl
              slug
            }
          }
        GQL
        }

        json = JSON.parse(response.body)
        data = json['data']['link']

        expect(data['originalUrl']).to eq('https://example.com')
        expect(data['slug']).to eq(link.slug)
      end
    end

    describe 'top_links' do
      before do
        links = create_list(:link, 3)
        links[0].update_columns(clicks_count: 10)
        links[2].update_columns(clicks_count: 5)
      end

      it 'returns links ordered by clicks_count' do
        post '/graphql', params: { query: <<~GQL
          query {
            topLinks(limit: 2) {
              slug
              clicksCount
            }
          }
        GQL
        }

        json = JSON.parse(response.body)
        data = json['data']['topLinks']

        expect(data.length).to eq(2)
        expect(data[0]['clicksCount']).to eq(10)
        expect(data[1]['clicksCount']).to eq(5)
      end
    end
  end
end
