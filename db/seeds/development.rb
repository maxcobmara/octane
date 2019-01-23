require 'faker'
require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation, :only =>
  []
)
