class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note_id, :set_sharenote
  include Users
  layout 'user'

  def index
    @users = @sharenote == 'true' ? shareable_users(@note_id) : get_users
  end

  def shared_to
    user_id = params[:user_id]
    mode = params[:mode] || nil
    @error, @users = note_shrare_to_user(mode, user_id, @note_id, @sharenote)
  end

  def remove
    user_id = params[:user_id]
    mode = params[:mode] || nil
    @error, @users = remove_permission(mode, user_id, @note_id, @sharenote)
  end

  private

  def set_note_id
    @note_id ||= params[:note_id]
  end

  def set_sharenote
    @sharenote = params[:sharenote]
  end

end
