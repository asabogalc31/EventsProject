class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  config.web_console.whiny_requests = false
end
