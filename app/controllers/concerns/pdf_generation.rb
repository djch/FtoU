# app/controllers/concerns/pdf_generation.rb
module PdfGeneration
  extend ActiveSupport::Concern

  def wicked_pdf_params
    {
      pdf: "ftou_order_receipt",
      page_size: 'A4',
      orientation: 'Portrait',
      template: "deliveries/sheets/show",
      formats: [:html],
      layout: 'layouts/pdf',
      print_media_type: true
    }
  end
end
