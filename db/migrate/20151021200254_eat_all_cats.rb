class EatAllCats < ActiveRecord::Migration
  def change
    add_column :cat_rental_requests, :user_id, :integer, null: false, index: true
  end
end
