class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
      t.string :password, :null => false
      t.string :token, :null => true

      t.index :username, unique: true
      t.index :email, unique: true
      t.index :token, unique: true
      t.timestamps
    end
  end
end
