class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [ :create ]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    # Check role param and verify user role matches
    user = User.find_by(email: params[:user][:email])
    if user
      role_param = params[:user][:role]
      if role_param.present? && user.role != role_param
        flash.now[:alert] = "Selected role does not match your user role."
        respond_with resource, location: new_user_session_path and return
      end
    end
    super
  end

  protected

  # Permit the role parameter along with others
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :role ])
  end
end
