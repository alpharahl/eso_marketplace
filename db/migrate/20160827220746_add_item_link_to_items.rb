class AddItemLinkToItems < ActiveRecord::Migration
  def change
  	add_column :items, :item_link, :string
  end
end
