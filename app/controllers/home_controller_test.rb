require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end
end

test "index renders the index template" do
  get home_index_url
  assert_template :index
end

test "index assigns correct template and response" do
  get home_index_url
  assert_response :success
  assert_template :index
end

test "index route is routable" do
  assert_routing "/home/index", controller: "home", action: "index"
end
