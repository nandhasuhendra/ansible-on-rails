class MainController < ActionController::Base
  def index
    render template: 'layouts/application'
  end
end

