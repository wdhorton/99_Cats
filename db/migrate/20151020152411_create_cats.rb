class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.datetime :birth_date, presence: true
      t.string :color
      t.string :name, presence: true
      t.string :sex, limit: 1, presence: true
      t.text :description
    end
  end
end
