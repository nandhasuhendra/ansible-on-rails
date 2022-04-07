require 'test_helper'

class Api::V1::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get signup" do
    get api_v1_registrations_signup_url
    assert_response :success
  end

end
