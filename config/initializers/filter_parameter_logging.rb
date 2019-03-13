# frozen_string_literal: true

# Sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %w(
                                                   password
                                                   confirm_password
                                                )
