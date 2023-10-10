# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  def confirmation_for_customer
    order = Order.last
    OrderMailer.confirmation_for_customer(order)
  end
end
