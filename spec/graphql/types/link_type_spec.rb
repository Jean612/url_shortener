require 'rails_helper'

module Types
  RSpec.describe LinkType, type: :request do
    describe 'clicks' do
      let!(:link) { create(:link) }
      let!(:clicks) { create_list(:click, 5, link: link) }

      it 'returns paginated clicks' do
        post '/graphql', params: { query: <<~GQL
          query {
            link(slug: "#{link.slug}") {
              clicks(first: 2) {
                edges {
                  node {
                    id
                  }
                  cursor
                }
                pageInfo {
                  hasNextPage
                  endCursor
                }
              }
            }
          }
        GQL
        }

        json = JSON.parse(response.body)
        data = json['data']['link']['clicks']

        expect(data['edges'].length).to eq(2)
        expect(data['pageInfo']['hasNextPage']).to be true
        expect(data['edges'][0]['node']['id']).to eq(clicks[0].id.to_s)
        expect(data['edges'][1]['node']['id']).to eq(clicks[1].id.to_s)
      end
    end
  end
end
