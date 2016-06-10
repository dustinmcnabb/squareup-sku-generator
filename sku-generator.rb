#!/usr/bin/ruby
require 'csv'

=begin
The purpose of this script is to read a Square inventory csv export and automatically generate SKUs using an abbreviated  Category-Name-VariantName scheme. It loops through all 40 allowed variants looking for any variant with a non-nil and non-empty Variant Name and then sets a SKU accordingly. This assumes that if a variant name has been set in the in the inventory then there is a valid product to be managed as a Stock Keeping Unit.

Current Limitations
    Duplicate SKUs are allowed. This must be fixed.
    The script assumes the name of the original csv will be inventory.csv and reads and writes to the local current working directory.
    The maximum variants allowed by square is statically set. This could be an issue if Square allows more variants in the future.
    By removing non-alphanumeric chaaracters after generating the sku format some names are more abbreviated than they would be otherwise
    Common abbreviations are not enforced. For example, SMAL should be SML, LARG - LRG, and REGU - REG as these would be more human readable.
=end

# Empty array for creating the updated_inventory.csv file
updated_inventory = []

variant = (1..40)

# Open the original inventory file named inventory.cvs with headers expected
CSV.foreach('inventory.csv', headers: true) do |product|
# Loops through the up to 40 allowed variants in Square inventory
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
                # Write the updated_inventory array including auto generated SKUs to the new csv.
                updated_inventory.each do |row|
                    csv.puts row
                end
            end
        end
    end
end
