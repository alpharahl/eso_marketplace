class Item < ActiveRecord::Base
	has_many :Sales

	def get_sales
		Sale.where("item_id='#{self.id}'")
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

	def self.import(addr)
		address = "#{Rails.root}/public/mm_input/#{addr}"
		lines = []
		File.open(address, 'r') do |file|
			while line = file.gets
				lines<<line
			end
        end

        file_type = lines.first[0..lines.first.index(" ")-1]
        # Remove the first 2 and last lines as they are unnecessary
        lines.delete lines.first
        #lines.delete_if{|line| line.index(/(?!\s)/) < 20}

        near_json = ""
        lines.each do |line|
        	line.strip!
            line.gsub! "]", ""
            line.gsub! "[", ""
            line.gsub! "=", ":"
            if line.include?(":") and not line.include?('"')
            	line = "\"#{line[0..line.index(":")-1]}\"#{line[line.index(":") .. -1]}"
            end
            near_json = "#{near_json}#{line}"
        end
        near_json.gsub! "\n", ""
        near_json.gsub! ",}", "}"
        near_json = "#{near_json[0..-2]}}"
        File.open("#{Rails.root}/public/mm_input/out.txt",'w'){ |file| file.write(near_json)}
        data = JSON.parse(near_json)

        
        data["Default"]["MasterMerchant"]["$AccountWide"]["SalesData"].each_value do |sale_data|
        	sale_data.each_value do |item_data|
        		item_data["sales"].each_value do |sale_value|
        			price     = sale_value["price"]
        			quant     = sale_value["quant"]
        			date      = Date.strptime(sale_value["timestamp"].to_s, "%s")
        			uniq      = sale_value["id"] || sale_value["timestamp"]
        			item_link = sale_value["itemLink"]

        			item = Item.find_by_item_link(item_link)
        			if item == nil
        				item = Item.new
        				item.name = item_data["itemDesc"]
        				item.item_link = item_link
        				item.save
        			end

        			sale = Sale.where("unique_id='#{uniq}'").first
        			if sale == nil
        				sale = Sale.new
        				sale.unique_id = uniq
        				sale.price     = price
        				sale.quantity  = quant
        				sale.date      = date
        				sale.item_id   = item.id
        				sale.save
        			end
        		end


        	end
        end

        Sale.count
    end

    def get_name
    	name = self.name
    	name.gsub! "^n", ""
    	name.gsub! "^p", ""
    	name
    end

  
end
