class SalesBelongsToItems < ActiveRecord::Migration
  def change
    change_table :sales do |s|
      s.belongs_to :item, index: true
    end
  end
end
