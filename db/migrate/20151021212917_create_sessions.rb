class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :user_id, null: false, index: true
      t.string :session_token
    end

    remove_column :users, :session_token
  end
end
