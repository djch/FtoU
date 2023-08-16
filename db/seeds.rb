# Customers
# -----------------------------------------------------------------------------

# Sample towns and postcodes from the Greater Hobart area of Tasmania
towns_and_postcodes = [
  { town: "Hobart", postcode: "7000" },
  { town: "Glenorchy", postcode: "7010" },
  { town: "Kingston", postcode: "7050" },
  { town: "Claremont", postcode: "7011" },
  { town: "Sandy Bay", postcode: "7005" },
  { town: "Bellerive", postcode: "7018" },
  { town: "Moonah", postcode: "7009" },
  { town: "Rosny Park", postcode: "7018" },
  { town: "Battery Point", postcode: "7004" },
  { town: "Blackmans Bay", postcode: "7052" },
  { town: "Lindisfarne", postcode: "7015" },
  { town: "Howrah", postcode: "7018" },
  { town: "Taroona", postcode: "7053" },
  { town: "South Hobart", postcode: "7004" },
  { town: "Mount Stuart", postcode: "7000" },
  { town: "West Hobart", postcode: "7000" },
  { town: "North Hobart", postcode: "7000" },
  { town: "Lenah Valley", postcode: "7008" },
  { town: "New Town", postcode: "7008" },
  { town: "Huonville", postcode: "7109" },
  { town: "Geeveston", postcode: "7116" }
]

# Iterate through a number of times to create customers
50.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  # Check if customer already exists
  next if Customer.exists?(first_name: first_name, last_name: last_name)

  town_and_postcode = towns_and_postcodes.sample

  Customer.create!(
    first_name: first_name,
    last_name: last_name,
    phone: "04#{Faker::Number.number(digits: 8)}",
    email: Faker::Internet.email(name: "#{first_name}_#{last_name}".downcase),
    street_address: "#{Faker::Number.number(digits: 3)} #{Faker::Address.street_name} St",
    town: town_and_postcode[:town],
    state: "TAS",
    postcode: town_and_postcode[:postcode],
    country: "Australia",
    delivery_notes: "Leave at the front door"
  )
end

# Products
# -----------------------------------------------------------------------------

products_data = [
  {
    title: "10 to 12 Inch Split Firewood",
    price: 130,
    unit: "bucket",
    available: true,
    description: "<div>Ideal for smaller or older fireboxes</div>"
  },
  {
    title: "12 to 15 Inch Split Firewood",
    price: 125,
    unit: "bucket",
    available: true,
    description: "<div>Most popular for larger fireplaces</div>"
  },
  {
    title: "Bagged Firewood",
    price: 120,
    unit: "bag",
    available: true,
    description: "<div>10KG bag of dried hardwood</div>"
  },
  {
    title: "Bagged Kindling",
    price: 120,
    unit: "bag",
    available: true,
    description: "<div>10KG bag of dried kindling<br>Lights quickly and easily to get your fire started</div>"
  },
  {
    title: "Bagged Sawdust",
    price: 120,
    unit: "bag",
    available: true,
    description: "<div>10KG bag of dried sawdust<br>Lights quickly and easily to get your fire started</div>"
  }
]

# Iterate through the products data and create products
products_data.each do |product_data|
  next if Product.exists?(title: product_data[:title])

  product = Product.create!(
    title: product_data[:title],
    price: product_data[:price],
    unit: product_data[:unit],
    available: product_data[:available]
  )
  product.description = product_data[:description] # Assigning rich text
  product.save!
end
