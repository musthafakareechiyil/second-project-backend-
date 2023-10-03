source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "rails", "~> 7.0.7", ">= 7.0.7.2"

gem "pg", "~> 1.1"

gem "puma", "~> 5.0"

gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  gem "faker", "~> 3.2" 

  gem "pry", "~> 0.14.2"

  gem 'rubocop', require: false

  gem "rubocop-rails", "~> 2.21", require: false
end

gem "bcrypt", "~> 3.1"

gem "jwt", "~> 2.7"

gem "rack-cors", "~> 2.0"

gem "acts_as_paranoid", "~> 0.8.1"

gem "googleauth", "~> 1.8"

gem "kaminari", "~> 1.2"
