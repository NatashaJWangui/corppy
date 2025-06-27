class HomeController < ApplicationController
  def index
     if current_user
      @current_registration = current_user.current_registration
      @completed_registrations = current_user.completed_registrations.limit(5)
     end
  end
end
