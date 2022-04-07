source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '5.2.2'
gem 'sqlite3', "~> 1.3.6"
gem 'puma', '~> 3.11'
gem 'foreman'
gem 'webpacker'
# gem 'jbuilder', '~> 2.5'
# gem 'redis', '~> 4.0'
# gem 'rack-cors'
# gem 'mini_magick', '~> 4.8'
gem 'bcrypt', '~> 3.1.7'
gem 'jwt', '~> 1.5', '>= 1.5.4'
gem 'dotenv'
gem 'net-ssh', '~> 4.2'

gem 'ed25519', '>= 1.2', '< 2.0', require: false
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0', require: false
gem 'bootsnap', '>= 1.1.0', require: false
gem 'whenever', '~> 0.9.4', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'faker', '~> 1.9', '>= 1.9.1'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano-rails'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
