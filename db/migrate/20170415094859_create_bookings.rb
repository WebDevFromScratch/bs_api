class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.string :client_email, null: false
      t.decimal :price, null: false, precision: 10, scale: 2

      t.references :rental, foreign_key: true, index: true, null: false
    end
  end
end
