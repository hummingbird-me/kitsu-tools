require 'test_helper'

class AppsControllerTest < ActionController::TestCase
  let(:josh) { users(:josh) }

  test 'can show your apps' do
    create(:app, creator: josh)

    sign_in josh
    get :mine
    assert_response 200
    assert_preloaded "apps"
  end

  test 'can get all apps by creator' do
    create(:app, creator: josh)

    sign_in josh
    get :index, format: :json, creator: josh.id
    assert_response 200
    assert_json_body({
      users: Array,
      apps: [
        {
          key: String,
          secret: String,
          name: String
        }
      ]
    })
  end

  test 'can get the data for a single app' do
    app = create(:app, creator: josh)

    sign_in josh
    get :show, format: :json, id: app.id
    assert_response 200
    assert_json_body({
      users: Array,
      app: {
        key: String,
        secret: String,
        name: String
      }
    })
  end

  test 'can create a new app' do
    sign_in josh

    # Generate the JSON in a helper method for the serialized version
    post :create, {
      app: {
        name: Faker::App.name,
        homepage: Faker::Internet.url,
        description: Faker::Lorem.sentence
      }
    }
    assert_response 200
  end

  test 'can edit an existing app if creator' do
    app = create(:app, creator: josh)
    sign_in josh

    new_name = Faker::Lorem.word
    post :update, {
      id: app.id,
      app: {
       name: new_name
      }
    }
    assert_response 200
    assert_json_body({
      users: Array,
      app: {
        key: String,
        secret: String,
        name: new_name
      }
    })
  end

  test 'cannot edit an existing app if not creator' do
    app = create(:app, creator: josh)
    sign_in users(:vikhyat)

    post :update, {
      id: app.id,
      app: {
        name: 'TOP KEK'
      }
    }
    assert_response 403
  end
end
