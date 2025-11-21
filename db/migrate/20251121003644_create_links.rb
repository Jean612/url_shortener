class CreateLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :links do |t|
      t.text :original_url
      t.string :slug
      t.integer :clicks_count

      t.timestamps
    end
    add_index :links, :slug, unique: true
  end
end
