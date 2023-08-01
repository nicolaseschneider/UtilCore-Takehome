require 'spec_helper'
require 'rails_helper'
describe 'Checking in and out' do
    let(:user1) { User.create() }
    let(:user2) { User.create() }
    let(:trip) { Trip.create(owners: [user1], assignees: [user2], estimated_arrival_time: '1/1/2023 8AM EST', estimated_completion_time: '1/1/2023 2PM EST') }
  
    it 'allows user2 to check in and out' do
        patch check_in_trip_path(trip.id), headers: { 'current_user_id': 1 }

        expect(response).to have_http_status(:success)
        expect(Trip.find(trip.id).status).to eq('in progress')
  
        patch check_out_trip_path(trip.id), headers: { 'current_user_id': user2.id }
        trip.reload
        expect(trip.status).to eq('completed')
    end
  end