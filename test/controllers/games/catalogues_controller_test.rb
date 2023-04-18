require "test_helper"

class Games::CataloguesTest < ActionDispatch::IntegrationTest
  test "GET index" do
    sign_in :jerry
    get game_catalogue_path

    assert_response :success
  end
end
