class Sale < ActiveRecord::Base
	belongs_to :Item

	def self.add_sale_to_item(opts)
		# opts should contain
		#    :price     = The price in gold the item sold for
		#    :item_name = The name of the item (what eso calls it)
		#    :date      = The date of the sale, will assume now if none known


		item = Item.get_or_create_item(opts[:item_name])
		s = Sale.new
		s.item_id = item.id
		s.price = opts[:price]
		s.date = opts[:date] || Time.now
		s.save
	end

	def display
		return {:date => self.date.day, :price => self.price}
	end
end