class TripAssignment < ApplicationRecord
  belongs_to :trip
  belongs_to :owner, class_name: 'User'
  belongs_to :assignee, class_name: 'User'
end
