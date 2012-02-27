#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  ActiveSupport::Dependencies.clear
  ActiveRecord::Base.instantiate_observers

  require 'rspec/autorun'
  require 'webmock/rspec'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  Capybara.run_server = true
  Capybara.server_port = 3001
  Capybara.app_host = "http://localhost:#{Capybara.server_port}"
  Capybara.server_boot_timeout = 50

  Capybara.javascript_driver = :webkit

  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    config.include ControllerMacros

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      WebMock.disable_net_connect!(:allow_localhost => true)

      # Disabling this to speed up testing... Just have to remember
      # to do it manually whenever assets are changed...
      # %x[bundle exec rake assets:precompile]
    end

    config.before(:each) do
      DatabaseCleaner.start
      ActiveRecord::Base.observers.disable :all
    end

    config.after(:each) do
      DatabaseCleaner.clean
      ActionMailer::Base.deliveries = []
      Timecop.return
    end

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  AppName::Application.reload_routes!
  Dir[Rails.root + "app/models/**/*.rb"].each { |m| load m }

  require 'factory_girl'
  FactoryGirl.factories.clear
  FactoryGirl.reload
end

