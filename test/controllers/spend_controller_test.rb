require "test_helper"

class SpendControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get spend_index_url
    assert_response :success
  end
end
