source 'https://rubygems.org'
ruby '2.5.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'airbrake'
gem 'aws-sdk'
gem 'bootstrap-sass'
gem 'bootstrap-wysihtml5-rails'
gem 'bootstrap3-datetimepicker-rails'
# gem 'chosen-rails'
gem 'coffee-rails'
gem 'colorize'
# gem 'compass-rails', github: 'Compass/compass-rails' # Required by chosen, needs to be explicit
gem 'compass-rails'
gem 'country_select'
gem 'devise'
gem 'font-awesome-rails'
gem 'honeypot-captcha'
gem 'jquery-rails'
gem 'localer'
gem 'mini_magick'
gem 'momentjs-rails', '~> 2.5.0'
gem 'newrelic_rpm'
gem 'nokogiri'
gem 'nprogress-rails'
gem 'paperclip'
gem 'pg', '~> 0.15'
gem 'premailer-rails'
gem 'protected_attributes' # Smoother upgrade to rails 4, provides attr_accessible
gem 'puma'
gem 'rack'
gem 'rails', '4.2.8'
gem 'rails_12factor', group: :production
gem 'rakismet'
gem 'sass-rails'
gem 'simple_form'
gem 'slim-rails'
gem 'split', require: 'split/dashboard'
gem 'textacular'
gem 'therubyracer'
# gem 'turbolinks'
gem 'uglifier'
gem 'will_paginate'
gem 'will_paginate-bootstrap'

group :development do
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'meta_request'
  gem 'pry-byebug'
  gem 'pry-coolline'
  gem 'rspec-collection_matchers'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker' # Generates names, emails and other placeholders for factories
  gem 'launchy'
  gem 'poltergeist'
  gem 'shoulda-matchers'
  gem 'timecop'
end
