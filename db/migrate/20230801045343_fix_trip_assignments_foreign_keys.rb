class FixTripAssignmentsForeignKeys < ActiveRecord::Migration[7.0]
  def up
    # drop the trip_assignments table
    drop_table :trip_assignments

    # create the trip_assignments table again with correct foreign keys
    create_table :trip_assignments do |t|
      t.belongs_to :trip, null: false, foreign_key: true
      t.belongs_to :owner, null: false, foreign_key: { to_table: :users }
      t.belongs_to :assignee, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end

  def down
    # just drop the table in the rollback
    drop_table :trip_assignments
  end
end
