require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'sample', email:'coco@dd.ua', password: 'foobar', password_confirmation: 'foobar')
  end

  test "sould be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ''
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email = ''
    assert_not @user.valid?
  end

  test "name should not to long" do
    @user.name = 'a'*51
    assert_not @user.valid?
  end
  test "email should not to long" do
    @user.email = 'a'*256
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_adreses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_adreses.each do |adress|
      @user.email = adress
      assert @user.valid?, "#{adress.inspect} should be valid"
    end
  end
  test "email validation should reject invalid addresses" do
    invalid_adreses = %w[user@example,com foo@bar..com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_adreses.each do |adress|
      @user.email = adress
      assert_not @user.valid?, "#{adress.inspect} should be invalid"
    end
  end
  test "email address should be saved as low-case" do
    difcase_email = "fOoBaR@GmAiL.CoM"
    @user.email = difcase_email
    @user.save
    assert_equal difcase_email.downcase, @user.reload.email
  end
  test "email adress should be unique" do
    dubl_user = @user.dup
    dubl_user.email = @user.email.upcase
    @user.save
    assert_not dubl_user.valid?
  end
  test "user password should be present" do
    @user.password = @user.password_confirmation  = ''*6
    assert_not @user.valid?, "sorry bro, but blank pass prokanal"
  end
  test "user password should have minimun length" do
    @user.password = @user.password_confirmation = 'a'*5
    assert_not @user.valid?, "sorry bro, but short pass prokanal"
  end
end

