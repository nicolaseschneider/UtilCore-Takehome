class User < ApplicationRecord
    has_many :owned_trip_assignments, class_name: 'TripAssignment', foreign_key: 'owner_id'
    has_many :assigned_trip_assignments, class_name: 'TripAssignment', foreign_key: 'assignee_id'
end
