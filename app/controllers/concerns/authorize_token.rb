module AuthorizeToken
  def validate_token
    token = get_header_token

    if !check_already_token
      raise(ErrorHandler::InvalidToken, Message.invalid_token)
    end

    if !check_expire(token)
      raise(ErrorHandler::InvalidToken, Message.token_expire)
    end
  end

  def get_current_user(token)
    @current_user = User.find_by_id(token[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    raise(ErrorHandler::InvalidToken, Message.invalid_token + ", " + e.message)
  end

  private
    def check_expire(token)
      Time.now.to_i < token[:exp]
    end

    def check_already_token
      token = request.headers['Authorization']

      User.find_by_token(token)
    end

    def get_header_token
      if request.headers['Authorization'].present?
        return JsonWebToken.decode(request.headers['Authorization'].split(' ').last)
      else
        raise(ErrorHandler::MissingToken, Message.missing_token)
      end
    end
end
