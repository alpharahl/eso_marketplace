class Item < ActiveRecord::Base
	has_many :Sales

	def getSales
		prices = Array.new
		Sale.where("item_id='#{self.id}'").each do |s|
			prices << {:price => s.price, :date => s.date}
		end
		prices
	end

	def self.get_or_create_item(item_name)
		item = Item.find_by_name(item_name)
		if item
			return item
		else
			return Item.new_item_name(item_name)
		end
	end

	def self.new_item_name (item_name)
		item = Item.new
		item.name = item_name
		item.save
		return item
	end
end
