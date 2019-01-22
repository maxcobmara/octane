source 'https://rubygems.org'

gem 'rails', '4.2.11'
# Use sqlite3 as the database for Active Record
#Operational Gems
gem 'pg',             '~> 0.17.1'
gem 'thin',           '~> 1.6.3'
gem 'devise',         '~> 3.5.1'
gem 'ancestry',       '~> 2.1.0'
gem 'ransack',        '~> 1.6.6'
gem 'chartkick',      '~> 1.3.2'
gem 'groupdate',      '~> 2.4.0'
gem 'declarative_authorization', git: 'https://github.com/stffn/declarative_authorization.git' #'~> 0.5.7'
gem 'roo',            '~> 2.3.2'
gem 'roo-xls',        '~> 1.1.0'

#Display Gems
gem 'sass',         '~> 3.4.13'
gem 'sass-rails',   '~> 5.0'
gem 'bootstrap-sass','~> 3.2.0.0'
gem 'bootstrap-select-rails', '~> 1.6.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.0.5'
gem 'jquery-ui-rails', '~> 5.0.3'
gem 'haml',         '~> 5.0.4'
gem 'haml-rails',   '~> 1.0.0'
gem "kaminari",     "~> 0.16.3"
gem "bootstrap-kaminari-views", "~> 0.0.3"
gem 'font-awesome-rails', '~> 4.3.0'



# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'quiet_assets', '~> 1.1.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.1.3'
  #gem 'spring'
  gem 'seed_dump', '~> 3.3', '>= 3.3.1'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.4.6'
end

group :production do
  gem 'rails_12factor', '0.0.2'
  gem 'capistrano'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'unicorn'
end
