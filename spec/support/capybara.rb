# frozen_string_literal: true

require 'capybara-screenshot/rspec'
require 'capybara/rails'
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.always_include_port   = true
Capybara.app_host              = 'http://localhost'
Capybara.asset_host            = 'http://localhost:3000'
# Capybara.default_driver        = :poltergeist
Capybara.default_host          = "http://localhost"
Capybara.default_max_wait_time = 5
# Capybara.default_wait_time     = 10
Capybara.javascript_driver     = :headless_chrome
# Capybara.javascript_driver     = :webkit #requires capybara-webkit
Capybara.run_server            = true
Capybara.server                = :puma, { Silent: true }
Capybara.server_host           = "localhost"
Capybara.server_port           = 3000

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu window-size=1024,768) }
    # on `disable-gpu` option:
    # The documentation for the headless Chrome indicates this is only temporarily necessary but does not specify why.
    # It’s not clear if this is necessary now that the feature is stable
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

# Capybara.save_path = ENV['CIRCLE_ARTIFACTS'] if ENV.key?('CIRCLE_ARTIFACTS')
Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end


RSpec.configure do |config|

  # Include Capybara's DSL as part of Rspec
  config.include Capybara::DSL

  config.around(:each) do |example|
    example.run
    Capybara.reset_sessions! # Clear session data
  end

end
