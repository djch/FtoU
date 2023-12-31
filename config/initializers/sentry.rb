if Rails.env.production?
  Sentry.init do |config|
    config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    config.traces_sample_rate = 0.1
  end
end