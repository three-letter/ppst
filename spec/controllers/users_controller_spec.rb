# coding: utf-8
require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do
    before(:each) do 
      @user = create(:user)
    end
    it "should be to login if no signin" do
      controller.stub(:current_user).and_return(nil)
      get :index
      response.should redirect_to login_path
    end
    it "should be index if has signin" do
      controller.stub(:current_user).and_return(@user)
      get :index
      response.should render_template(:index) 
    end
  end

  describe "GET 'new'" do
    it "should open new page success" do
      get :new
      response.should be_success
    end
    it "should hava right title" do
      get :new
      response.should have_selector("title", :content => "注册")
    end
    it "should not signup if has login" do
      user = create(:user)
      controller.stub(:current_user).and_return(user)
      get :new
      response.should redirect_to root_path
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @valid_user =  {:name => "chx2103", :pwd => "123456", :pwd_confirmation => "123456"} 
      @invalid_user = {:name => "", :pwd => "", :pwd_confirmation => ""} 
    end
    
    context "create user with invalid attr" do 
      it "should not create user" do
        lambda do
          post :create, :user => @invalid_user
        end.should_not change(User, :count) 
      end
      it "should render new " do
        post :create, :user => @invalid_user
        response.should render_template("new")
      end
    end

    context "create user with valid attr" do
      it "should create user success" do
        lambda do
          post :create, :user => @valid_user
        end.should change(User, :count).by(1)
      end
      it "should redirect index" do
        post :create, :user => @valid_user
        response.should redirect_to root_path
      end
    end
  end

  describe "GET 'show'" do
  end

  describe "GET 'edit'" do
  end

  describe "GET 'list'" do
  end

end
