ENV["RAILS_ENV"] ||= "test"

# SimpleCov must be required before loading the application
require "simplecov"
SimpleCov.start "rails" do
  add_filter "/test/"
  add_filter "/config/"
  add_filter "/vendor/"
  
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Services", "app/services"
end

require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
