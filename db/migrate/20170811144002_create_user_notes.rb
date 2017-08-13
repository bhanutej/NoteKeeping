class CreateUserNotes < ActiveRecord::Migration
  def change
    create_table :user_notes do |t|
      t.belongs_to :user
      t.belongs_to :note
      t.integer :parent_id, default: 0
      t.integer :shared_by, default: 0
      t.string :mode

      t.timestamps null: false
    end

    add_index :user_notes, :user_id
    add_index :user_notes, :note_id
    add_index :user_notes, :parent_id
    add_index :user_notes, [:note_id, :parent_id]
  end
end
