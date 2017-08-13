module Users

  def get_users
    User.active(current_user.id)
  end

  def get_note_create_user(note_id)
    UserNote.where(note_id: note_id, parent_id: 0, shared_by: 0, mode: 'owner').first
  end

  def get_current_user_note_owner(note_created_user, note_id)
    UserNote.where(note_id: note_id, user_id: current_user.id, parent_id: note_created_user.id, mode: 'owner').first
  end

  def get_shareable_users(s_users)
    User.where.not(id: [current_user.id, s_users].uniq)
  end

  def shareable_users(note_id)
    s_users = get_parent_users(note_id,  current_user.id, [])
    get_shareable_users(s_users)
  end

  def get_parent_users(note_id, user_id, shared_by = [])
    parent = get_parent(note_id)
    u_note = UserNote.where(note_id: note_id, user_id: user_id, parent_id: parent.id).first
    shared_by << u_note.shared_by if u_note.present?
    get_parent_users(note_id, u_note.shared_by, shared_by) if u_note.present? && u_note.shared_by != 0
    shared_by
  end

  def get_note_owner(user_id, note_id)
    UserNote.where(user_id: current_user.id, note_id: note_id, shared_by: user_id).first
  end

  def get_user(user_id)
    User.find_by_id(user_id)
  end

  def get_parent(note_id)
    UserNote.where(note_id: note_id, parent_id: 0).first
  end

  def get_user_note(parent_id, user_id, note_id)
    UserNote.where(user_id: user_id, note_id: note_id, parent_id: parent_id.id).first
  end

  def note_shrare_to_user(mode, user_id, note_id, sharenote)
    error, users = nil
    if mode.present?
      note_owner = get_note_owner(user_id, note_id)
      if note_owner.present?
        error = t('no_access_to_change_mode')
      else
        user = get_user(user_id)
        parent_id = get_parent(note_id)
        user_note = get_user_note(parent_id, user_id, note_id)
        user_note.destroy if user_note.present?
        user.user_notes.create({note_id: note_id, shared_by: current_user.id, mode: mode, parent_id: parent_id.id})
        users = sharenote == 'true' ? shareable_users(note_id) : get_users
      end
    else
      error = t('select_mode')
    end
    [error, users]
  end

  def remove_permission(mode, user_id, note_id, sharenote)
    error, users = nil
    if mode.present?
      note_owner = get_note_owner(user_id, note_id)
      if note_owner.present?
        error = t('no_access_to_remove')
      else
        parent = get_parent(note_id)
        user_ids = get_child_users(user_id, note_id) # user_id is nothing but shared_by
        user_ids = user_ids + [user_id]
        user_ids.each do |user_id|
          user_note = get_user_note(parent, user_id, note_id)
          user_note.destroy if user_note.present?
        end
        users = sharenote == 'true' ? shareable_users(note_id) : get_users
      end
    else
      error = t('not_have_mode')
    end
    [error, users]
  end

  def get_child_users(shared_by, note_id, user_ids = [])
    parent = get_parent(note_id)
    u_note = UserNote.where(note_id: note_id, parent_id: parent.id, shared_by: shared_by).first
    user_ids << u_note.user_id if u_note.present?
    get_child_users(u_note.user_id, note_id, user_ids) if u_note.present?
    user_ids
  end
end