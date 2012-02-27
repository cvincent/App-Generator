gem "nokogiri"
gem "paperclip"
gem "aws-sdk"
gem "kaminari"
gem "decent_exposure"
gem "flash_messages_helper"
gem "rack-p3p"
gem "validates_timeliness"
gem "attr_accessible_block"
gem "bcrypt-ruby"

gem "capybara-webkit", group: :test
gem "thin", group: :test # (for capybara)
gem "launchy", group: :test
gem "database_cleaner", group: :test
gem "timecop", group: :test
gem "spork", require: false, group: :test
gem "webmock", group: :test
gem "faker", group: :test

gem "rspec-rails", group: [:test, :development]
gem "factory_girl", require: false, group: [:test, :development]

gem "guard", group: :development
gem "guard-spork", group: :development
gem "guard-rspec", group: :development

application "config.generators.stylesheet_engine = :sass"
application "config.sass.preferred_syntax = :sass"
application <<-EOF
if Rails.env.test?
  initializer :after => :initialize_dependency_mechanism do
    ActiveSupport::Dependencies.mechanism = :load
  end
end
EOF

run 'bundle install --path=vendor'
run 'rm -rf test/'

generate "rspec:install"

remove_file "spec/spec_helper.rb"
create_file "spec/spec_helper.rb", File.read(File.expand_path("spec/spec_helper.rb", File.dirname(__FILE__)))
create_file "spec/support/controller_macros.rb", File.read(File.expand_path("spec/support/controller_macros.rb", File.dirname(__FILE__)))
create_file "Guardfile", File.read(File.expand_path("Guardfile", File.dirname(__FILE__)))
create_file ".rvmrc", "rvm use rb19@rails32"

append_file ".gitignore", "/vendor/ruby"
append_file ".gitignore", ".DS_Store"
append_file ".gitignore", "/public/system/**/*"

git :init
git add: '.'
git commit: '-m "Initial commit."'

# TODO:
# - Bourbon by default, maybe with default starting layout.
# - Capistrano deploy script.
# - validates_timeliness config/initializer.
# - Replace AppName constant in spec_helper.rb.
# - Use mysql2 gem and config for database.
# - Add initializer to silence assets messages in dev/test logs.
