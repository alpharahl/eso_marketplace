class AddItemIdToSale < ActiveRecord::Migration
  def change
    add_foreign_key :sales, :items
    add_column      :sales, :price, :integer
    add_column      :sales, :date,  :date
  end
end
