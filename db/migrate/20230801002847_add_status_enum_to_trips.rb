class AddStatusEnumToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :status, :string, :null => false, :default => 'unstarted'
  end
end
