class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :event_name, :null => false
      t.string :event_place, :null => false
      t.string :event_address, :null => false
      t.date :event_initial_date, :null => false
      t.date :event_final_date, :null => true
      t.string :thumbnail, :null => true

      t.belongs_to :user, foreign_key: true
      t.belongs_to :category, foreign_key: true
      t.belongs_to :type_event, foreign_key: true

      t.timestamps
    end
  end
end
