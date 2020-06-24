module UserHelpers
  def fail_user_creation(user_params)
    get '/signup'
    assert_response :success
    assert_no_difference 'User.count' do
      post signup_path, params: { user: user_params }
    end
    assert_select 'div.alert-danger'
    assert_match 'Failed to create account', response.body    
  end

  def try_user_update(user, password = "password")
    patch user_url(user), params: {
      user: {
        username: "editedname",
        email: user.email,
        password: password
      }
    }
    User.find(user.id)
  end
end