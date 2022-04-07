class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :validate_token

  def signup
    @user = User.new(set_params)

    if @user.save
      render_json({ data: @user })
    else
      render_json({ data: @user.errors.messages }, :unprocessable_entity)
    end
  end

  private
    def set_params
      senitizer(params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation))
    end
end

