class CreateCatRentalRequests < ActiveRecord::Migration
  def change
    create_table :cat_rental_requests do |t|
      t.integer :cat_id, null: false, index: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :status, default: "Pending"

      t.timestamps
    end

    change_table :cats do |t|
      t.timestamps
    end
  end
end
