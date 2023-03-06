require 'simplecov'
SimpleCov.start 'rails' do

  add_filter "app/controllers/users/"
  add_filter "app/channels"
  add_filter "app/mailers"
  add_filter "app/jobs"
end
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: 1)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  setup do 
    User.all.each do |user|
      if user.name != "Jona"
        user.confirm
      end
    end
    user = User.invite!({email: "ejemplo2@ejemplo.com", empresa: users(:one).empresa}, users(:one))
  end
  # Add more helper methods to be used by all tests here...
end
