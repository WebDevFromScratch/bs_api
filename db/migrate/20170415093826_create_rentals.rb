class CreateRentals < ActiveRecord::Migration[5.0]
  def change
    create_table :rentals do |t|
      t.string  :name, null: false
      t.decimal :daily_rate, null: false, precision: 10, scale: 2

      t.timestamps
    end

    add_index :rentals, :name, unique: true
  end
end
