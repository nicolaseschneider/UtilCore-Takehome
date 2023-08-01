class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.datetime :estimated_arrival_time
      t.datetime :estimated_completion_time
      t.datetime :check_in_time
      t.datetime :check_out_time

      t.timestamps
    end
  end
end
