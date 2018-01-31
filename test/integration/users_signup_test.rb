require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', count:8
  end
  test "valid signup information and redirect after success signup" do
    get signup_path
    assert_difference 'User.count',1 do
      post users_path, params: { user:{ name: "normal name",
                                        email: "normal@email.com",
                                        password: 'foobar',
                                        password_confirmation: 'foobar'} }
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash.any?
    assert_select 'div.alert-success'
  end
end
