class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all

    render_json({ data: @users })
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(set_params)

    if @user.valid?
      render_json({ data: @user })
    else
      render_json({ data: @user.errors.messages }, :unprocessable_entity)
    end
  end

  def show
      render_json({ data: @user })
  end

  def update
    if @user.update_attributes(set_params)
      render_json({ data: @user })
    else
      render_json({ data: @user.errors.messages }, :unprocessable_entity)
    end
  end

  def destroy
    if @user.destroy
      render_json({ data: @user })
    else
      render_json({ data: @user.errors.messages }, :unprocessable_entity)
    end
  end

  private
    def set_user
      @user = User.find_by_id!(params[:id])
    end

    def set_params
      senitizer(params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation))
    end
end
