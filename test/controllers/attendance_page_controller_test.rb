require 'test_helper'

class AttendancePageControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get attendance_page_top_url
    assert_response :success
  end

end
