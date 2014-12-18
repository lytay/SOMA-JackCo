class UsersController < ApplicationController
  # load_and_authorize_resource
  # before_filter :authenticate_user!

  def index
    begin
      @user = User.new

      if params[:user] and params[:user][:name] and !params[:user][:name].nil?
        @users = User.find_by_name(params[:user][:name]).page(params[:page]).per(5)
      else
        @users = User.page(params[:page]).per(5)
      end
    rescue Exception => e
      puts e
    end
  end

  def show
    begin
      @user = User.find(params[:id])
    rescue Exception => e
      puts e
    end
  end

  def new
    begin
      @user = User.new
    rescue Exception => e
      puts e
    end
  end

  def create
    begin
      @user = User.new(user_params)
      @user.resource_ids = params[:user][:resource_ids]
      
      if @user.save!
        flash[:notice] = "User has been created successfully"
        redirect_to users_path
      else
        flash[:notice] = "User can't save"
        redirect_to :back
      end
    rescue Exception => e
      puts s
    end
  end

  def edit_profile
    begin
      @user_account = User.find(params[:id])
    rescue Exception => e
      puts e
    end
  end

  def update_profile
    begin
      @user_account = User.find(params[:id])

      if @user_account.update_attributes!(account_update_params)
        flash[:notice] = "User updated"
        redirect_to users_path
      else
        redirect_to :back
      end
    rescue Exception => e
      puts e
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    begin
      @user = User.find(params[:id])
      @user.resource_ids = params[:user][:resource_ids]
      
      if @user.update_attributes!(user_params)
        flash[:notice] = "User updated"
        redirect_to users_path
      else
        redirect_to :back
      end
    rescue Exception => e
      puts e
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :role)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end
