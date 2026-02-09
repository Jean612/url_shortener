class AddIndexToLinksClicksCount < ActiveRecord::Migration[8.1]
  def change
    add_index :links, :clicks_count
  end
end
