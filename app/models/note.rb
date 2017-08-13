class Note < ActiveRecord::Base

  has_many :user_notes, dependent: :destroy
  has_many :note_tags, dependent: :destroy

  validates_presence_of :note

end
