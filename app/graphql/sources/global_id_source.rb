# frozen_string_literal: true

module Sources
  class GlobalIdSource < GraphQL::Dataloader::Source
    def fetch(ids)
      objects = GlobalID::Locator.locate_many(ids)
      # Index by global ID string to maintain order and return correct object
      objects_by_id = objects.index_by { |obj| obj.to_gid_param }

      ids.map { |id| objects_by_id[id] }
    end
  end
end
