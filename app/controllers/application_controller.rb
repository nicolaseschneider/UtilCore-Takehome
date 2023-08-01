class ApplicationController < ActionController::API
    before_action :set_current_user

    private
  
    def set_current_user
      # This will cause an n+1 query on each request. To fix, Implement Caching.
      @current_user ||= User.find(request.headers["HTTP_CURRENT_USER_ID"])
      render json: { error: 'Not authenticated' }, status: :unauthorized unless @current_user
    end
end
