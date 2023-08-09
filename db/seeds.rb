# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Sample towns and postcodes from the Greater Hobart area of Tasmania
towns_and_postcodes = [
  { town: "Hobart", postcode: "7000" },
  { town: "Glenorchy", postcode: "7010" },
  { town: "Kingston", postcode: "7050" },
  { town: "Claremont", postcode: "7011" },
  { town: "Sandy Bay", postcode: "7005" },
]

# Randomly generated sample names
names = [
  "John Smith", "Jane Johnson", "Robert Brown", "Emily Davis", "William Taylor",
  "Mary Wilson", "James White", "Patricia Harris", "Charles Clark", "Linda Lewis",
]

# Iterate through the towns and names to create customers
names.each_with_index do |name, index|
  town_and_postcode = towns_and_postcodes.sample

  Customer.create!(
    name: name,
    phone: "04#{Faker::Number.number(digits: 8)}", # Random mobile number with Australian prefix
    email: Faker::Internet.email(name: name.downcase.gsub(" ", "_")),
    street_address: "#{Faker::Number.number(digits: 3)} #{Faker::Address.street_name} St",
    town: town_and_postcode[:town],
    state: "TAS",
    postcode: town_and_postcode[:postcode],
    country: "Australia",
    delivery_notes: "Leave at the front door"
  )
end
