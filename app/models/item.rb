class Item < ActiveRecord::Base
	has_many :Sales

	def getSales
		prices = Array.new
		Sale.where("item_id='#{self.id}'").each do |s|
			prices << [s.price, s.date]
		end
		prices
	end
end
