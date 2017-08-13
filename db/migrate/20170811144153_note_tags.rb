class NoteTags < ActiveRecord::Migration
  def change
    create_table :note_tags do |t|
      t.belongs_to :note
      t.belongs_to :tag
      t.timestamps null: false
    end

    add_index :note_tags, :note_id
    add_index :note_tags, :tag_id
  end
end
