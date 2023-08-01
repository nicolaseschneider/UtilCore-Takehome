class TripsController < ApplicationController

    # GET /TRIPS
    def index
        assignments = TripAssignment.includes(:trip)
            .where('owner_id = ? OR assignee_id = ?', @current_user.id, @current_user.id)
            .references(:trip)
        
        render json: assignments.map { |assignment| assignment_as_json(assignment) }
    end

    def create
        trip = Trip.new(trip_params)
        if trip.save
            renderable = trip.as_json
            renderable["assignee_id"] = trip_params[:trip_assignments_attributes][0][:assignee_id]
            renderable["owner_id"] = @current_user.id
            render json: renderable, status: :created
        else
            render json: task.errors, status: :unprocessable_entity
        end
    end

    def check_in
        trip = Trip.includes(:trip_assignments).find(params[:id])

        if trip.status == "in progress"
            render json: { error: "Trip already checked in!" }, status: :bad_request
            return
        end

        if trip.trip_assignments.last.assignee_id == @current_user.id 
            trip.update_columns(check_in_time: Time.current, status: "in progress")
            render json: trip, status: :ok
        else
            render json: { error: 'Not authorized' }, status: :unauthorized
        end
    end

    
    def check_out
        trip = Trip.includes(:trip_assignments).find(params[:id])

        if trip.status != "in progress"
            render json: { error: "Cannot check out a trip not in progress"}, status: :bad_request
            return
        end

        if trip.trip_assignments.last.assignee_id == @current_user.id
            trip.update_columns(check_out_time: Time.current, status: "completed")
            render json: trip, status: :ok
        else
            render json: { error: 'Not authorized' }, status: :unauthorized
        end
    end
    
    # PATCH/PUT /trips/:id
    def update
        trip = Trip.find(params[:id])
        if trip.update(update_trip_params)
            render json: trip
        else
            render json: trip.errors, status: :unprocessable_entity
        end
    end

    # PUT /trips/:id/reassign
    def reassign
        trip = Trip.includes(:trip_assignments).find(params[:id])

        if trip.trip_assignments.last.assignee_id != @current_user.id 
            render json: { error: 'Not authorized' }, status: :unauthorized
            return
        end
        
        trip.trip_assignments.each do |assignment| 
            if assignment.id == reassignment_params[:assignee_id]
                render json: { error: 'This user was already assigned this trip'}, status: :bad_request
                return
            end
        end

        

    end

    private

    def reassignment_params
        params.require(:trip).permit(:assignee_id)
    end

    def trip_params
        parameters = params.require(:trip).permit(:estimated_arrival_time, :estimated_completion_time, trip_assignments_attributes: [:assignee_id])

        parameters[:trip_assignments_attributes].each do |assignment|
            assignment[:owner_id] = @current_user.id
        end

        parameters
    end

    def update_trip_params
        params.require(:trip).permit(:estimated_arrival_time, :estimated_completion_time)
    end

    def assignment_as_json(assignment)
        json = assignment.trip.attributes
        json[:owner_id] = assignment.owner_id
        json[:assignee_id] = assignment.assignee_id
        json
    end
end
