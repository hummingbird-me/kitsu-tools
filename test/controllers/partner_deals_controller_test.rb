require 'test_helper'

class PartnerDealsControllerTest < ActionController::TestCase
  test "can get list of deals" do
    get :index
    assert_response 200
    assert_includes JSON.parse(@response.body), "partner_deals"
    assert_equal 2, JSON.parse(@response.body)["partner_deals"].length
  end

  test "must be a pro user to redeem" do
    sign_in users(:vikhyat)

    put :update, id: partner_deals(:one).id
    assert_response 401
  end

  test "can redeem a code as a pro user" do
    sign_in users(:josh)

    put :update, id: partner_deals(:one).id
    assert_response 200
    assert_equal "abcdefg", @response.body

    # doing another redeem returns the same code
    put :update, id: partner_deals(:one).id
    assert_response 200
    assert_equal "abcdefg", @response.body
  end

  test "limits deals by requestors country" do
    @request.env["HTTP_CF_IPCOUNTRY"] = "US"
    get :index
    assert_response 200
    assert_includes JSON.parse(@response.body), "partner_deals"
    assert_equal 2, JSON.parse(@response.body)["partner_deals"].length

    # deal only includes ["US", "AU"]
    @request.env["HTTP_CF_IPCOUNTRY"] = "NZ"
    get :index
    assert_response 200
    assert_includes JSON.parse(@response.body), "partner_deals"
    assert_equal 1, JSON.parse(@response.body)["partner_deals"].length
  end
end
