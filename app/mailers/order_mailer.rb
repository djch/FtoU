class OrderMailer < ApplicationMailer
  include PdfGeneration

  def confirmation_for_customer(order)
    return if order.customer.email.blank?

    @order = order
    attach_receipt(@order)
    mail(
      to: @order.customer.email,
      reply_to: "Firewood To U <#{ENV.fetch('STAFF_CONTACT_EMAIL', 'orders@firewoodtou.com.au')}>",
      subject: "Your Order Confirmation (##{order.id})"
    )
  end

  def notification_for_staff(order)
    @recipients = User.where(receive_order_notifications: true)
    @order = order
    attach_receipt(@order)
    mail(
      to: "Staff <#{ENV.fetch('STAFF_CONTACT_EMAIL', 'orders@firewoodtou.com.au')}>",
      cc: @recipients.map(&:email),
      subject: "Order placed by #{order.customer.name.familiar} (##{order.id})"
    )
  end

  private

    def attach_receipt(order)
      pdf = WickedPdf.new.pdf_from_string(
        render_to_string(wicked_pdf_params.merge(assigns: { order: order, is_pdf: true }))
      )
      attachments["order_receipt.pdf"] = { mime_type: 'application/pdf', content: pdf }
    end
end
