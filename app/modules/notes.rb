module Notes
  include Tags

  def get_my_notes
    Note.joins(:user_notes).where('user_notes.user_id': current_user.id, 'user_notes.parent_id': 0)
  end

  def get_my_shared_notes
    Note.joins(:user_notes).where('user_notes.user_id': current_user.id).where.not('user_notes.parent_id': 0).select('id', 'note', 'mode', 'parent_id', 'shared_by')
  end

  def create_note(note_param)
    Note.create({note: note_param})
  end

  def get_note(note_id)
    Note.find_by_id(note_id)
  end

  def create_note_tags(note, tags_param)
    if tags_param.present?
      tags_param.each do |tag|
        tag = create_tag(tag)
        note.note_tags.create(tag: tag)
      end
    end
  end

  def update_note(note, note_param)
    note.update_attributes({note: note_param})
  end

  def remove_all_note_tags(note)
    note.note_tags.map(&:destroy)
  end

  def refactor_note_tags(new_tags, note, tags_param)
    existed_tag_ids = note.note_tags.map(&:tag_id)
    tags_param.each do |tag|
      if tag.include? 'tag@$@'
        new_tags << tag.split('@$@')[1].to_i
      else
        new_tag = create_tag(tag)
        note.note_tags.create(tag: new_tag)
        new_tags << new_tag.id
      end
    end
    removed_tags = existed_tag_ids - new_tags
    note.note_tags.where(tag_id: removed_tags).map(&:destroy)
  end
end