class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :restrict_signup, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role ])
  end

  def restrict_signup
    if params[:controller] == "devise/registrations" && params[:action] == "new" && current_user&.admin?
      redirect_to root_path, alert: "Admins are not allowed to sign up."
    end
  end

  def after_sign_in_path_for(resource)
    return admin_path if resource.admin?
    return customer_path(resource) if resource.customer?
    if resource.delivery_partner? && resource.delivery_partner.present?
      return delivery_partner_path(resource.delivery_partner)
    end
    root_path
  end
end
