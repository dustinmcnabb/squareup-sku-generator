#!/usr/bin/ruby
require 'csv'

updated_inventory = []
# Currently Square allows 40 variants per item. Each one needs it's own SKU
variant = (1..40)

CSV.foreach('inventory.csv', headers: true) do |product|
    variant.each do |num|
        # Ignore empty or nil variants
        unless product["Variant #{num} - Name"].nil? || product["Variant #{num} - Name"].length == 0
            # Set SKU to an all caps abbreviation of the Category, Name, and Variant Name
            sku = product["Category"].to_s[0..7].upcase + "-" + product["Name"].to_s[0..7].upcase + "-" + product["Variant #{num} - Name"].to_s[0..3].upcase
            product["Variant #{num} - SKU"] =  sku
            # Remove any non alpha-numeric characters with the exception of hyphens.
            product["Variant #{num} - SKU"] = product["Variant #{num} - SKU"].gsub(/[^0-9a-z-]/i, '')
            updated_inventory << product
            column_names = product.headers
            CSV.open('updated_inventory.csv', 'w') do |csv|
                # Set the column names or headers from the original csv
                csv << column_names
                updated_inventory.each do |row|
                    csv.puts row
                end
            end
        end
    end
end
