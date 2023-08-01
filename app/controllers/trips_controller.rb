class TripsController < ApplicationController

    # GET /trips
    def index
        assignments = TripAssignment.includes(:trip)
            .where('owner_id = ? OR assignee_id = ?', @current_user.id, @current_user.id)
            .references(:trip)
        
        render json: assignments.map { |assignment| assignment_as_json(assignment) }
    end

    # GET /trips/:id
    # def show
    #     assignments = TripAssignment.includes(:trip)
    #         .where('owner_id = ? OR assignee_id = ?', @current_user.id, @current_user.id)
    #         .where('trip_id = ?', params[:id])
    #         .references(:trip)
    #     render json: assignments.map { |assignment| assignment_as_json(assignment) }
    # end

    # POST /trips
    def create
        trip = Trip.new(trip_params)
        if trip.save
            trip_assignment = Trip.includes(:trip_assignments).find(trip.id).trip_assignments.last
            render json: assignment_as_json(trip_assignment), status: :created
        else
            render json: trip.errors, status: :unprocessable_entity
        end
    end

    # PATCH /trips/:id/check_in
    def check_in
        trip = Trip.includes(:trip_assignments).find(params[:id])
        most_recent_assignment = trip.trip_assignments.last
        if trip.status == "in progress"
            render json: { error: "Trip already checked in!" }, status: :bad_request
            return
        end

        if most_recent_assignment.assignee_id == @current_user.id 
            trip.update_columns(check_in_time: Time.current, status: "in progress")
            render json: trip, status: :ok
        else
            render json: { error: 'Not authorized' }, status: :unauthorized
        end
    end

    # PATCH /trips/:id/check_out
    def check_out
        trip = Trip.includes(:trip_assignments).find(params[:id])
        most_recent_assignment = trip.trip_assignments.last
        if trip.status != "in progress"
            render json: { error: "Cannot check out a trip not in progress"}, status: :bad_request
            return
        end

        if most_recent_assignment.assignee_id == @current_user.id
            trip.update_columns(check_out_time: Time.current, status: "completed")
            render json: trip, status: :ok
        else
            render json: { error: 'Not authorized' }, status: :unauthorized
        end
    end
    
    # # PATCH/PUT /trips/:id
    # def update
    #     trip = Trip.find(params[:id])
    #     if trip.update(update_trip_params)
    #         render json: trip
    #     else
    #         render json: trip.errors, status: :unprocessable_entity
    #     end
    # end

    # PUT /trips/:id/reassign
    def reassign
        trip = Trip.includes(:trip_assignments).find(params[:id])

        if trip.status != "unstarted"
            render json: { error: "Only an unstarted trip may be reassigned"}, status: :bad_request
            return
        end

        if trip.trip_assignments.last.assignee_id != @current_user.id 
            render json: { error: 'Not authorized' }, status: :unauthorized
            return
        end
        
        trip.trip_assignments.each do |assignment| 
            if assignment.assignee_id == reassignment_params[:assignee_id] or assignment.owner_id == reassignment_params[:assignee_id]
                render json: { error: 'This user was already involved with this trip'}, status: :bad_request
                return
            end
        end
        
        trip_assignment = TripAssignment.new(trip_id: trip.id, owner_id: @current_user.id, assignee_id: reassignment_params[:assignee_id])
        if trip_assignment.save
            render json: { success: true, message: 'Trip assignment created.' }
        else
            render json: { success: false, message: trip_assignment.errors.full_messages.to_sentence }
        ends

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

    # def update_trip_params
    #     params.require(:trip).permit(:estimated_arrival_time, :estimated_completion_time)
    # end

    def assignment_as_json(assignment)
        json = assignment.trip.attributes
        json[:owner_id] = assignment.owner_id
        json[:assignee_id] = assignment.assignee_id
        json
    end
end
