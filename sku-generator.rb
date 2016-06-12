#!/usr/bin/ruby -w

require 'csv'

column_names = []
updated_inventory = []

def gen_skus(product,num)
    # Set SKU to an all caps abbreviation of the Category, Name, Variant Name, and Variant Number
    product_category = product["Category"].to_s.upcase.tr('^0-9A-Z ', '').split(' ').map { |word| word.slice(0..4) }.join.slice(0..7)
    product_name = product["Name"].to_s.upcase.tr('^0-9A-Z ', '').split(' ').map { |word| word.slice(0..4) }.join.slice(0..7)
    product_variant = product["Variant #{num} - Name"].to_s.upcase.tr('^0-9A-Z ', '').split(' ').map { |word| word.slice(0..2) }.join.slice(0..5)
    product["Variant #{num} - SKU"] = product_category + "-" + product_name + "-" + product_variant + num.to_s
end

def update_inventory(product,updated_inventory)
    updated_inventory << product
end
    
def create_updated_csv(column_names,updated_inventory)
    CSV.open('updated_inventory.csv', 'w') do |csv|
    # Set the column names or headers from the original csv
       # puts updated_inventory
        csv << column_names
        updated_inventory.each do |row|
        #    puts row
            csv << row
        end
    end
end

CSV.foreach('inventory.csv', headers: true) do |product|
# Currently Square allows 40 variants per item. Each one needs it's own SKU
variant = (1..41)
column_names = product.headers
    variant.each do |num|
        # Ignore empty or nil variants
        if product["Variant #{num} - Name"] && product["Variant #{num} - Name"].length != 0
            gen_skus(product,num)
        else 
            update_inventory(product,updated_inventory)
            break
        end
    end
end

create_updated_csv(column_names,updated_inventory)


#CSV.foreach('inventory.csv', headers: true) do |product|
#    variant.each do |num|
#        # Ignore empty or nil variants
#        unless product["Variant #{num} - Name"].nil? || product["Variant #{num} - Name"].length == 0
#            # Set SKU to an all caps abbreviation of the Category, Name, and Variant Name
#            sku = product["Category"].to_s[0..7] + "-" + product["Name"].to_s[0..7] + "-" + product["Variant #{num} - Name"].to_s[0..3]
#            product["Variant #{num} - SKU"] =  sku
#            # Remove any non alpha-numeric characters with the exception of hyphens.
#            product["Variant #{num} - SKU"] = product["Variant #{num} - SKU"].upcase.tr('^0-9A-Z-', '')
#            updated_inventory << product
#            column_names = product.headers
#            CSV.open('updated_inventory.csv', 'w') do |csv|
#                # Set the column names or headers from the original csv
#                csv << column_names
#                updated_inventory.each do |row|
#                    csv.puts row
#                end
#            end
#        end
#    end
#end
