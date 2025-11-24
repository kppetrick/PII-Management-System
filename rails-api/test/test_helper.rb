ENV["RAILS_ENV"] ||= "test"

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
require "mocha/minitest"
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

at_exit do
  ActiveRecord::Base.connection_pool.disconnect! if ActiveRecord::Base.connection_pool
end

module ActiveSupport
  class TestCase
    fixtures :all
  end
end
