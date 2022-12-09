ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

class ActionDispatch::IntegrationTest
  def sign_in(user_fixture_key)
    post session_path, params: { session: { token: users(user_fixture_key).token } }
    follow_redirect!

    assert_response :success
  end
end

class ViewComponent::TestCase
  def new_component(...)
    self.class.name.sub(/Test$/, "").constantize.new(...)
  end
end
