class UsersController < ApplicationController
  load_and_authorize_resource except: :create

  add_breadcrumb "All Users", :users_path

  def index
    begin
      @user = User.new

      if params[:user] and params[:user][:email] and !params[:user][:email].nil?
        @users = User.find_by_email(params[:user][:email]).page(params[:page]).per(5)
      else
        @users = User.page(params[:page]).per(5).order("email ASC")
      end
    rescue Exception => e
      puts e
    end
  end

  def show
    @user = User.find(params[:id])
    add_breadcrumb @user.email, :user_path
  end

  def new
    @user = User.new
    @user_groups = UserGroup.where(active: true)
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:notice] = "User has been created successfully"
      redirect_to users_path
    else
      flash[:notice] = "User can't be saved"
      # redirect_to :back
      render 'new'
    end
  end

  def edit_profile
    @user_account = User.find(params[:id])
    add_breadcrumb @user_account.email, :edit_profile_user_path
  end

  def update_profile
    @user_account = User.find(params[:id])

    if @user_account.update_attributes(account_update_params)
      flash[:notice] = "User updated"
      redirect_to users_path
    else
      # redirect_to :back
      render 'edit'
    end
  end

  def edit
    puts "================================"
    puts params[:id]
    @user = User.find(params[:id])
    @user_groups = UserGroup.where(active: true)
    add_breadcrumb @user.email, :edit_user_path
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      flash[:notice] = "User updated"
      redirect_to users_path
    else
      # redirect_to :back
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :user_group_id, :active)
  end

  private
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end