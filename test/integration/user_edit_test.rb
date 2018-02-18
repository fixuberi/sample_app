require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest

  def setup
  @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'qqq@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar'} }
    assert_template 'users/edit'
    assert_select 'div#error_explanation' do |elements|
      assert_select elements, 'ul' do |elements|
        assert_select elements, 'li', count:4
      end
    end
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "foo bar"
    email = "qwe@qwe.rty"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  test "stored forvarding_url should be delete after redirecting" do
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    log_out
    assert_redirected_to root_url
    log_in_as(@user)
    assert_redirected_to @user
  end
end
