# frozen_string_literal: true
module SAML
  # This class is responsible for putting together a complete ruby-saml
  # SETTINGS object, meaning, our static SP settings + the IDP settings
  # which must be fetched once and only once via IDP metadata.
  require 'singleton'
  class SettingsService
    include Singleton

    attr_reader :saml_settings

    def initialize
      @saml_settings ||= fetch_idp_metadata
    end

    private

    def settings
      # populate with SP settings
      settings = OneLogin::RubySaml::Settings.new
      settings.certificate  = SAML_CONFIG['certificate']
      settings.private_key  = SAML_CONFIG['key']
      settings.issuer       = SAML_CONFIG['issuer']
      settings.assertion_consumer_service_url = SAML_CONFIG['callback_url']

      settings
    end

    ## Makes an external web call to get IDP metadata and populates SETTINGS
    def fetch_idp_metadata
      parser = OneLogin::RubySaml::IdpMetadataParser.new
      parser.parse_remote(SAML_CONFIG['metadata_url'], true, settings: settings)
    end
  end
end