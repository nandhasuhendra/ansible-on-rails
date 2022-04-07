class Api::V1::AuthenticatesController < ApplicationController
  skip_before_action :validate_token

  def login
    @user = User.find_by_username(set_params[:username])

    if @user.nil? || !@user.authenticate(set_params[:password])
      raise(ErrorHandler::AuthenticateError, Message.authenticate_error)
    end

    token = JsonWebToken.encode({user_id: @user.id})

    if @user.update_attributes(token: token)
      render_json({
        auth: {
          token: token
        }
      })
    else
      render_json({ data: @user.errors.messages }, :unprocessable_entity)
    end
  end

  protected
    def set_params
      senitizer(params.require('auth').permit(:username, :password))
    end
end
