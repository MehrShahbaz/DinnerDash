# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  include ApplicationsConcern
  include Pundit::Authorization
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_cart

  rescue_from ActionController::RoutingError, with: :render404
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized_error

  def render404
    redirect_to(request.referer || root_path)
  end

  def record_not_found
    flash[:notice] = 'Unable to find the records.'
    redirect_to(request.referer || root_path)
  end

  def not_authorized_error
    flash[:notice] = 'You are not authorized for this action.'
    redirect_to root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:name, :email, :password, :first_name, :last_name, :user_name, :status)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :email, :password, :current_password, :first_name, :last_name, :user_name, :status)
    end
  end
end
