class RequireTripEstimatedTimes < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:trips, :estimated_arrival_time, false)
    change_column_null(:trips, :estimated_completion_time, false)
  end
end
