class ApplicationController < ActionController::API
  include Response
  include ParamsSenitizer
  include ErrorHandler
  include AuthorizeToken
  
  before_action :validate_token
end
