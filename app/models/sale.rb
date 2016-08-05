class Sale < ActiveRecord::Base
	belongs_to :Item

	def self.add_sale_to_item(opts)
		item = Item.get_or_create_item(opts[:item_name])
		s = Sale.new
		s.item_id = item.id
		s.price = opts[:price]
		s.date = opts[:date] || Time.now
		s.save
	end
end