class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.string :server
      t.string :reserver

      t.timestamps
    end
  end
end
