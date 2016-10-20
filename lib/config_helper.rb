# frozen_string_literal: true
require 'feature_flipper'

module ConfigHelper
  module_function

  def setup_action_mailer(config)
    if FeatureFlipper.send_email?
      config.action_mailer.delivery_method = :govdelivery_tms
      config.action_mailer.govdelivery_tms_settings = {
        auth_token: ENV['GOVDELIVERY_TOKEN'],
        api_root: "https://#{FeatureFlipper.staging_email? ? 'stage-' : ''}tms.govdelivery.com"
      }
    end
  end
end
