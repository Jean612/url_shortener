require 'rails_helper'

module Mutations
  RSpec.describe CreateLink, type: :request do
    describe '.resolve' do
      it 'creates a new link' do
        expect {
          post '/graphql', params: { query: <<~GQL
            mutation {
              createLink(input: { originalUrl: "https://example.com" }) {
                link {
                  originalUrl
                  slug
                  shortUrl
                }
                errors
              }
            }
          GQL
          }
        }.to change(Link, :count).by(1)

        json = JSON.parse(response.body)
        data = json['data']['createLink']

        expect(data['link']['originalUrl']).to eq('https://example.com')
        expect(data['link']['slug']).to be_present
        expect(data['link']['shortUrl']).to be_present
        expect(data['errors']).to be_empty
      end

      it 'returns errors for invalid URL' do
        expect {
          post '/graphql', params: { query: <<~GQL
            mutation {
              createLink(input: { originalUrl: "invalid-url" }) {
                link {
                  slug
                }
                errors
              }
            }
          GQL
          }
        }.not_to change(Link, :count)

        json = JSON.parse(response.body)
        data = json['data']['createLink']

        expect(data['link']).to be_nil
        expect(data['errors']).not_to be_empty
      end
    end
  end
end
