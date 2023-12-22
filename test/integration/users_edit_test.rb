require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select 'div.field_with_errors', 'Name'
    assert_select 'div#error_explanation' do
      assert_select 'div.alert', 'The form contains 4 errors.'
      assert_select 'ul li', 'Name can\'t be blank'
      assert_select 'ul li', 'Email is invalid'
      assert_select 'ul li', 'Password confirmation doesn\'t match Password'
      assert_select 'ul li', 'Password is too short (minimum is 6 characters)'
    end
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
