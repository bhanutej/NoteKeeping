class NotesController < ApplicationController
  before_action :authenticate_user!
  include Notes
  include Tags
  layout 'user'

  def index
    @notes = get_my_notes
  end

  def new
    @note = Note.new
    @sharenote = 'false'
  end

  def create
    note_param = params[:note][:note]
    tags_param = params[:tags] || nil
    note = create_note(note_param)
    if note.errors.blank?
      note.user_notes.create({ user: current_user, parent_id: 0, shared_by: 0, mode: 'owner' })
      create_note_tags(note, tags_param)
      @notes = get_my_notes
    else
      @errors = note.errors.full_messages
    end
  end

  def update
    @sharenote = params[:sharenote]
    note_id = params[:id]
    note_param = params[:note][:note]
    tags_param = params[:tags] || nil
    note = get_note(note_id)
    update_note(note, note_param)
    new_tags = []
    if note.errors.blank?
      tags_param.blank? ? remove_all_note_tags(note) : refactor_note_tags(new_tags, note, tags_param)
      @notes = @sharenote == 'true' ? get_my_shared_notes : get_my_notes
    else
      @errors = note.errors.full_messages
    end
  end

  def edit
    @sharenote = params[:sharenote]
    note_id = params[:id]
    @note = get_note(note_id)
  end

  def show
    note_id = params[:id]
    @note = get_note(note_id)
  end

  def shared_notes
    @notes = get_my_shared_notes
  end

  def tag_notes
    tag_id = params[:tag_id]
    tag = Tag.find_by_id(tag_id)
    @note_tags = tag.note_tags
  end

  def destroy
    note_id = params[:id]
    get_note(note_id).destroy
    @notes = get_my_notes
  end
end
