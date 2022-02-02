class ApplicationController < ActionController::Base
  include Pagy::Backend

  def configure_permitted_parameters
    # configure_permitted_parameters.
    #
    # @return [true] if parameters are permitted
    devise_parameter_sanitizer.for(:sign_up){|u|u.permit(:email,:password,:password_confirmation)}
  end
end
