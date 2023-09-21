# Set up integration with the MailChimp API

Gibbon::Request.api_key = Rails.application.credentials.dig(:mailchimp, :api_key)
Gibbon::Request.timeout = 15  # Default is 30s
