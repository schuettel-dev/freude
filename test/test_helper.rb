ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  fixtures :all

  def assert_permit(user, record, action)
    assert(
      permit(user, record, action),
      "User #{user.inspect} should be permitted to #{action} #{record}, but isn't permitted"
    )
  end

  def assert_not_permit(user, record, action)
    assert_not(
      permit(user, record, action),
      "User #{user.inspect} should NOT be permitted to #{action} #{record}, but is permitted"
    )
  end

  def permit(user, record, action)
    cls = self.class.to_s.gsub(/Test/, "")
    cls.constantize.new(user, record).public_send(action)
  end
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
