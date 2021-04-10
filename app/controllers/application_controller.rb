class ApplicationController < ActionController::Base
  include Pagy::Backend
	def configure_permitted_parameters    
		devise_parameter_sanitizer.for(:sign_up){|u|u.permit(:email,:password,:password_confirmation)}
	end
end
