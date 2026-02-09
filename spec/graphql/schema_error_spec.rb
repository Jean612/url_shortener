# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlShortenerSchema do
  describe '.type_error' do
    let(:link) { create(:link) }

    # We will query for the link's `original_url` which is non-nullable in the schema.
    # By forcing it to nil in the database (bypassing validations), we trigger GraphQL::InvalidNullError.
    let(:query) do
      <<~GQL
        query($id: ID!) {
          node(id: $id) {
            ... on Link {
              originalUrl
            }
          }
        }
      GQL
    end

    before do
      # Bypass validations to set a required field to nil
      link.update_column(:original_url, nil)
    end

    it 'logs GraphQL::InvalidNullError to Rails.logger' do
      # We expect Rails.logger.error to be called with a message indicating a GraphQL error
      expect(Rails.logger).to receive(:error).with(/GraphQL Error:/)

      # Execute the query
      UrlShortenerSchema.execute(
        query,
        variables: { id: link.to_global_id.to_s }
      )
    end
  end
end
