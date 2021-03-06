#!/usr/bin/ruby -w

require 'csv'

column_names = []
updated_inventory = []

# Generate SKUs using an all caps abbreviation of the Category, Name, Variant Name, Variant Number, and a random number.
def gen_skus(product,num)
    skus = []
    product_category = product["Category"].to_s.upcase.tr('^0-9A-Z ', '').split(' ').map { |word| word.slice(0..3) }.join.slice(0..6)
    product_name = product["Name"].to_s.upcase.tr('^0-9A-Z ', '').split(' ').map { |word| word.slice(0..3) }.join.slice(0..6)
    product_variant = product["Variant #{num} - Name"].to_s.upcase.tr('^0-9A-Z', '').slice(0..2)
    product["Variant #{num} - SKU"] = [product_category, product_name, product_variant, (num.to_s + rand(100..1000).to_s)].join("-")
    skus << product["Variant #{num} - SKU"]
end
    
def create_updated_csv(column_names,updated_inventory)
    CSV.open('updated_inventory.csv', 'w') do |csv|
        csv << column_names
        updated_inventory.each do |row|
            csv << row
        end
    end
end

CSV.foreach('itemsbulk-template.csv', headers: true) do |product|
# Currently Square allows 40 variants per item. 
# Each one needs it's own SKU. We have to iterate to 41 to prevent ignoring items with 40 variants.
num = 1
column_names = product.headers
    while product["Variant #{num} - Name"] && product["Variant #{num} - Name"].length != 0
        gen_skus(product,num)
        num += 1
    end 
updated_inventory << product
end

create_updated_csv(column_names,updated_inventory)
