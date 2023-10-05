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
    price: 12,
    unit: "bag",
    available: true,
    description: "<div>10KG bag of dried hardwood</div>"
  },
  {
    title: "Bagged Kindling",
    price: 12,
    unit: "bag",
    available: true,
    description: "<div>10KG bag of dried kindling<br>Lights quickly and easily to get your fire started</div>"
  },
  {
    title: "Bagged Sawdust",
    price: 12,
    unit: "bag",
    available: true,
    description: "<div>10KG bag of dried sawdust<br>Lights quickly and easily to get your fire started</div>"
  }
]

products_data.each do |product_data|
  next if Product.exists?(title: product_data[:title]) # Skip if the product exists already

  product = Product.create!(
    title: product_data[:title],
    price: product_data[:price],
    unit: product_data[:unit],
    available: product_data[:available]
  )
  product.description = product_data[:description] # Assigning rich text
  product.save!
end

# Customers & Orders
# -----------------------------------------------------------------------------

# Disable Mailchimp callbacks for seeding
Customer.skip_callback(:create, :after, :add_to_mailchimp)
Customer.skip_callback(:update, :after, :update_in_mailchimp)
Customer.skip_callback(:destroy, :after, :remove_from_mailchimp)

# Clear existing records
OrderItem.delete_all
Order.delete_all
Customer.delete_all

# Define the start date as 30 days ago from today
start_date = Date.today - 50.days

# Helper method to ensure delivery dates don't fall on weekends
def next_weekday(date)
  return date unless date.saturday? || date.sunday?
  loop do
    date = date + 1.day
    break unless date.saturday? || date.sunday?
  end
  date
end

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

pending_order_count = 0
delivery_counts = Hash.new(0)

# Start from 30 days ago and go up to today
(start_date..Date.today).each do |current_day|

  # Decide the number of orders for the day
  orders_for_the_day = rand(5..12)

  orders_for_the_day.times do
    # Use 'current_day' as your current_day

    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    company_name = Faker::Company.name

    town_and_postcode = towns_and_postcodes.sample

    # Ensure phone numbers and emails match the expected patterns
    phone_number = "04#{Faker::Number.number(digits: 8)}"
    email_address = Faker::Internet.email(name: "#{first_name}_#{last_name}".downcase)

  customer = Customer.create!(
    first_name: first_name,
    last_name: last_name,
    phone: phone_number,
    email: email_address,
    street_address: "#{Faker::Number.number(digits: 3)} #{Faker::Address.street_name} St",
    town: town_and_postcode[:town],
    state: "TAS",
    postcode: town_and_postcode[:postcode],
    country: "Australia",
    delivery_notes: "Leave at the front door",
    created_at: current_day,
    updated_at: current_day
  )

  Order.transaction do
    # Determine the order status
    order_statuses = [
      'confirmed', 'confirmed', 'confirmed', 'confirmed', 'confirmed',
      'confirmed', 'confirmed', 'confirmed', 'confirmed', 'confirmed',
      'delivered', 'delivered', 'delivered', 'delivered', 'delivered',
      'delivered', 'delivered', 'delivered', 'delivered', 'pending'
    ]
    order_status = order_statuses.sample

    if order_status == 'pending' && pending_order_count >= 12
      order_status = ['confirmed', 'delivered'].sample
    else
      pending_order_count += 1 if order_status == 'pending'
    end

    # First, determine the delivery date
    if order_status == 'confirmed' || order_status == 'delivered'
        proposed_delivery_date = current_day + rand(7..14).days
        proposed_delivery_date = next_weekday(proposed_delivery_date)

        while delivery_counts[proposed_delivery_date] >= 12
            proposed_delivery_date = next_weekday(proposed_delivery_date + 1.day)
        end

        delivery_date = proposed_delivery_date
        delivery_counts[delivery_date] += 1
    else
        delivery_date = nil
    end

    # If the delivery date is in the past, the order is 'delivered'
    if delivery_date && delivery_date <= Date.today
        order_status = 'delivered'
    end

    # Set delivery time for all orders with a delivery date
    if delivery_date
        delivery_seconds = rand(9..17).hours.to_i + [0, 15, 30, 45].sample.minutes.to_i
        delivery_date = delivery_date + delivery_seconds.seconds
    end

    order = customer.orders.build(
      status: order_status,
      delivery_date: delivery_date,
      first_name: first_name,
      last_name: last_name,
      company_name: company_name,
      phone: customer.phone,
      created_at: current_day,
      updated_at: current_day,
      delivery_fee: order_status == 'pending' ? nil : [50, 60, 70, 80].sample,
      paid: order_status == 'confirmed' ? [true, false].sample : false
    )


      # For each order, add between 1 to 3 unique order items
      products_for_this_order = Product.all.sample(rand(1..Product.count))
      products_for_this_order.each do |product|
        order.order_items.build(
          product: product,
          quantity: (1..6).to_a.sample,
          created_at: current_day,
          updated_at: current_day
        )
      end

      order.save!
    end
  end
end

# Past orders should have been delivered already
Order.where("delivery_date <= ?", Date.today).update_all(status: 'delivered')