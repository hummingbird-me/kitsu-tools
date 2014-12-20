require 'test_helper'

class ProMembershipsControllerTest < ActionController::TestCase
  test "must be signed in" do
    post :create
    assert_response 403
  end

  class SignedInProMembershipsControllerTest < ActionController::TestCase
    setup do
      sign_in users(:vikhyat)
    end

    test "requires both token and valid plan_id" do
      requests = [{}, {plan_id: 5}, {token: ""}, {token: "derp"},
                  {token: "", plan_id: 5}, {token: "derp", plan_id: -1}]

      requests.each do |req|
        post :create, req
        assert_response 400
      end
    end

    # TODO more tests.
  end
end
