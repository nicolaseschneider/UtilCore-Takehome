class CreateTripAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :trip_assignments do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: true
      t.references :assignee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
