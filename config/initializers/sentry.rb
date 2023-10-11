if Rails.env.production?
  Sentry.init do |config|
    config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # TODO: reduce sampling rate before we go live
    config.traces_sample_rate = 1.0
  end
end