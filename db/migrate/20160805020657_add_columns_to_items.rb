class AddColumnsToItems < ActiveRecord::Migration
  def change
    add_column :items, :item_id, :string
    add_column :items, :name,    :string
    add_column :items, :rarity,  :integer
  end
end
