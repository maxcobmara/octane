source 'https://rubygems.org'

gem 'rails', '~> 5.0.7.2'   #March 29, 2018
# Use sqlite3 as the database for Active Record
#Operational Gems
#gem 'pg',             '~> 0.17.1'. <-- pg unable to install use sqllite instead
gem 'sqlite3',         '~> 1.3.13'
gem 'thin',           '~> 1.8rstart.0'
gem 'devise',         '~> 4.0.0'
gem 'ancestry',       '~> 3.2.1'
gem 'ransack',        '~> 2.0.0'
gem 'chartkick',      '~> 1.3.2'
gem 'groupdate',      '~> 3.0.0'
#gem 'declarative_authorization', git: 'https://github.com/stffn/declarative_authorization.git' #'~> 0.5.7'
#gem 'authoreyes',   '~> 0.2.0'
#gem 'declarative_authorization', git: 'https://github.com/Xymist/declarative_authorization.git'
gem 'cancancan',    '~> 2.2'


gem 'roo',            '~> 2.5.0'
#gem 'roo-xls',        '~> 1.2.0'<-- deprecated

#Display Gems
gem 'sass',         '~> 3.5.0'
gem 'sass-rails',   '~> 6.0.0'
gem 'bootstrap-sass','~> 3.4.0'
gem 'bootstrap-select-rails', '~> 1.6.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.4.O'
gem 'jquery-ui-rails', '~> 6.0.0' #--- deprecated?

gem 'haml',         '~> 5.1.0'
gem 'slim',         '~> 4.0.0'   #<-- migrate haml to slim as you go
# 'haml-rails',   '~> 1.0.0'
gem "kaminari",     "~> 1.2.0"
#gem "bootstrap-kaminari-views", "~> 0.0.3" deprecated
gem 'font-awesome-rails', '~> 4.5.0'

#compatability
#gem 'bigdecimal', '1.3.0'
gem 'loofah', '~> 2.9.0'
gem 'nokogiri', '~> 1.10.0'



# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
#gem 'quiet_assets', '~> 1.1.0' <-- deprecated

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'web-console', '~> 3.4.0'
  gem 'seed_dump', '~> 3.3', '>= 3.3.1'
end


group :production do
  gem 'rails_12factor', '0.0.2'
  #gem 'capistrano'
  #gem 'capistrano-rails', '~> 1.1'
  #gem 'capistrano-bundler'
  #gem 'capistrano-rvm'
  #gem 'unicorn'
end
