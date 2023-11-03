# app/models/spina/parts/available_products.rb
module Spina
  module Parts
    class AvailableProducts < Base
      def content
        ::Product.by_price.where(available: true)
      end
    end
  end
end
