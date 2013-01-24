#coding:utf-8
require 'spec_helper'

describe User do
  
  describe "all validates for the field of user" do
    subject { create(:user) }
    
    it { should validate_presence_of(:name).with_message("用户名不能为空") }
    it { should validate_uniqueness_of(:name).with_message("用户名已经存在") }
    it { should ensure_length_of(:name).is_at_least(2).with_short_message("用户名长度为2到8").is_at_most(8).with_long_message("用户名长度为2到8") }
    it { should validate_presence_of(:pwd).with_message("密码不能为空") }
    it { should validate_confirmation_of(:pwd).with_message("两次密码不一致") }
  end

  describe "user info verify" do
    before(:each) do 
      @user = create(:user)
      @user1 = create(:user)
    end

    # encrypt by sha2,other private methods also can test by this case
    it "should be true if give password is right" do
      @user.has_password?(@user.pwd).should be_true
    end
    it "should be false if give password is invalid" do
      @user.has_password?(@user1.pwd).should be_false
    end

    # user authenticate by name and password
    it "should return user if valid info" do
      User.authenticate(@user.name, @user.pwd).should == @user
    end
    it "should return nil if invalid info" do
      User.authenticate(@user.name, @user1.pwd).should == nil
    end
    
    # user authenticate by token
    it "should return user if valid token" do
      User.authenticate_by_token(@user.id, @user.salt).should == @user
    end
    it "should return nil if invalid token" do
      User.authenticate_by_token(@user.id, @user1.salt).should == nil
    end

  end

end
