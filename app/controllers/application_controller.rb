class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  config.web_console.whitelisted_ips = '157.253.238.244'
end
