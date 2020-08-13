class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name, :null => false
      t.string :location, :null => false
      t.string :address, :null => false
      t.date :initial_date, :null => false
      t.date :final_date, :null => true
      t.string :thumbnail, :null => true

      t.belongs_to :user, foreign_key: true
      t.belongs_to :category, foreign_key: true
      t.belongs_to :event_type, foreign_key: true

      t.timestamps
    end
  end
end
