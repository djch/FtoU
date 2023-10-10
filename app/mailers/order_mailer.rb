class OrderMailer < ApplicationMailer
  include PdfGeneration

  def confirmation_for_customer(order)
    @order = order

    pdf = WickedPdf.new.pdf_from_string(
      render_to_string(wicked_pdf_params.merge(assigns: { order: order, is_pdf: true }))
    )
    attachments["order_receipt.pdf"] = { mime_type: 'application/pdf', content: pdf }

    mail(to: @order.customer.email, subject: "Your Order Confirmation (##{order.id})")
  end
end
