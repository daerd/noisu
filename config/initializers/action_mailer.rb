# frozen_string_literal: true

Rails.application.config.action_mailer.delivery_method = :smtp

Rails.application.config.action_mailer.smtp_settings = {
  address:              ENV["SMTP_ADDRESS"],
  port:                 ENV["SMTP_PORT"].to_i,
  domain:               ENV["SMTP_DOMAIN"],
  user_name:            ENV["SMTP_USERNAME"],
  password:             ENV["SMTP_PASSWORD"],
  authentication:       ENV["SMTP_AUTH"],
  enable_starttls_auto: ENV["SMTP_ENABLE_STARTTLS_AUTO"] == "true"
}

Rails.application.config.action_mailer.default_url_options = {
  host: ENV["ACTION_MAILER_HOST"]
}

Rails.application.config.action_mailer.default_options = {
  from: ENV["ACTION_MAILER_DEFAULT_FROM"]
}
