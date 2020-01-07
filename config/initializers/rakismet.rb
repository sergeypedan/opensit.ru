# frozen_string_literal: true

# http://akismet.com
# https://github.com/joshfrench/rakismet
# gem 'rakismet'

Opensit::Application.configure do

  config.rakismet.key = ENV["RAKISMET_KEY"]
  config.rakismet.url = ENV["DOMAIN"]

end
