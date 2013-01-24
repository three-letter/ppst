# coding: utf-8
require 'spec_helper'

describe SessionsController do
  render_views

  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
  end
  
  describe "GET 'new'" do
    it "should be success" do
      get :new
      response.should be_success
    end
    it "should open login page" do
      get :new
      response.should have_selector("title", :content => "登陆")
    end
    it "should message if haved login" do
      post :create, :name => @user1.name, :pwd => @user1.pwd 
      get :new
      response.should redirect_to root_path
    end
  end

  describe "POST 'create'" do
    context "no authenticate to login" do
      it "should render login" do
        post :create, :name => @user1.name, :pwd => @user2.pwd
        response.should render_template("new")
      end
    end

    context "hava authenticate to login" do
      it "should redirect after login success" do
        post :create, :name => @user1.name, :pwd => @user1.pwd
        response.should redirect_to users_path
      end
      it "sholud be current user after login success" do
        post :create, :name => @user1.name, :pwd => @user1.pwd
        controller.current_user.should == @user1
        controller.should be_sign_in
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "should be success" do
      controller.stub(:current_user).and_return(@user1)
      delete :destroy
      response.should redirect_to root_path
    end
    it "should be redirect to login if not signin" do
      controller.stub(:current_user).and_return(nil)
      delete :destroy
      response.should redirect_to login_path
    end
  end

end
