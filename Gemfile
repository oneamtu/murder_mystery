source 'https://rubygems.org'

# base
gem "sinatra"
gem "sinatra-contrib"
gem "rake"

# console
gem "tux"
gem "pry"
gem "pry-rescue"

# view
gem "haml"
gem "redcarpet"

# DB
gem "data_mapper"

group :production do
  gem "pg"
  gem "dm-postgres-adapter"
end

group :development, :test do
  gem "sqlite3"
  gem "dm-sqlite-adapter"
end
