# frozen_string_literal: true

module Sources
  # A Dataloader source for batch loading ActiveRecord associations.
  class ActiveRecordAssociation < GraphQL::Dataloader::Source
    def initialize(association_name)
      @association_name = association_name
    end

    def fetch(records)
      ::ActiveRecord::Associations::Preloader.new(records: records, associations: @association_name).call
      records.map { |record| record.public_send(@association_name) }
    end
  end
end
