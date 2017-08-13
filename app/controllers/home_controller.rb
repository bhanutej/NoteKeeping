class HomeController < ApplicationController
  before_action :authenticate_user!
  include Notes
  layout 'app', only: %i(index)
  layout 'user', only: %i(dashboard)
  def index
    redirect_to dashboard_home_index_path
  end

  def dashboard
    @my_notes = get_my_notes
    @shared_notes = get_my_shared_notes
  end
end
