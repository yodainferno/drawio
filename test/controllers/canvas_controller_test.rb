require "test_helper"

class CanvasControllerTest < ActionDispatch::IntegrationTest
  test "should get paint" do
    get canvas_paint_url
    assert_response :success
  end

  test "should get my" do
    get canvas_my_url
    assert_response :success
  end

  test "should get gallery" do
    get canvas_gallery_url
    assert_response :success
  end
end
