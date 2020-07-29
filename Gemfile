source 'https://rubygems.org'
ruby File.read(".ruby-version").strip

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.2.3'
gem 'bootsnap', '1.4.5'
gem 'pg', '0.21.0'
gem 'puma', '4.3.1'
gem 'validates_timeliness', '~> 4.1.1'
gem 'aasm', '~> 4.12.3'
gem 'lograge', '~> 0.11.2'
gem 'business'
gem "roo", "~> 2.8.0"

# SOAP Interaction
gem 'savon', '~> 2.12.0'

# emailing
gem 'sendgrid-ruby'
gem 'oauth2'
gem 'microsoft_graph', github: 'microsoftgraph/msgraph-sdk-ruby'

# Parsing
gem 'nokogiri', '~> 1.10.4'

# PDF Report Generation
gem 'ttfunk', '1.6.2.1'
gem 'prawn', '~> 2.2.2'
gem 'prawn-table', '~> 0.2.2'
gem 'squid', '~> 1.4.1'
gem 'rmagick'

# Asset Pipeline
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'

# Auth
gem 'devise', '~> 4.7.1'
gem 'devise_invitable', '~> 1.7.2'

# Storage & Uploads
gem 'carrierwave', '1.3.0'
gem 'fog-aws', '2.0.1'

# Front End
gem 'jquery-rails', '4.3.5'
gem 'turbolinks', '5.2.1'
gem 'bootstrap', '~> 4.3.1'
gem 'cocoon', '1.2.14'
gem 'remotipart', '1.4.3'
gem 'holidays', '~> 6.4'

# Error Reporting
gem 'honeybadger', '~> 4.0'

# Pagination
gem 'kaminari'
gem 'bootstrap4-kaminari-views'

# Searching
gem 'ransack'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
  gem 'rails-assets-pikaday', '~> 1.6.1'
  gem 'rails-assets-momentjs', '~> 2.18.1'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'httplog', '~> 0.99.2'
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener', '~> 1.4.1'
  gem 'rails-erd'
end
gem 'sdoc'

group :test do
  gem 'capybara', '~> 2.18'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper', '~> 2.0.0'
  gem 'mocha', '~> 1.3.0'
  gem 'webmock', '>= 3.6'
  gem 'pdf-reader', '~> 2.1.0'
end

group :production do
  gem 'aws-sdk-rails', '2.1.0' # Email via SES
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
