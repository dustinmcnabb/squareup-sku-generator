# squareup-sku-generator
Generate SKUs for squareup.com csv exports.

The purpose of this script is to read a Square inventory csv export and automatically generate SKUs using an abbreviated  Category-Name-VariantName scheme. It loops through all 40 allowed variants looking for any variant with a non-nil and non-empty Variant Name and then sets a SKU accordingly. This assumes that if a variant name has been set in the in the inventory then there is a valid product to be managed as a Stock Keeping Unit.

Current Limitations:

    1. Duplicate SKUs are allowed. This must be fixed.
    2. The script assumes the name of the original csv will be inventory.csv and reads and writes to the local current working directory.
    3. The maximum variants allowed by square is statically set. This could be an issue if Square allows more variants in the future.
    4. By removing non-alphanumeric chaaracters after generating the sku format some names are more abbreviated than they would be otherwise
    5. Common abbreviations are not enforced. For example, SMAL should be SML, LARG - LRG, and REGU - REG as these would be more human readable.
