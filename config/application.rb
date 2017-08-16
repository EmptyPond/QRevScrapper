require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QrevenueScrapper
  class Application < Rails::Application
    #For loading Lib and Vendor
    config.eager_load_paths += [ Rails.root.join('lib'), Rails.root.join('vendor') ]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
