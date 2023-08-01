class Trip < ApplicationRecord
    has_many :trip_assignments
    has_many :assignees, through: :trip_assignments, source: :assignee
    has_many :owners, through: :trip_assignments, source: :owner
  
    accepts_nested_attributes_for :trip_assignments
  end
  