module Tasks
  class HoursSpentsController < ApplicationController
    before_action :set_hours_spent, only: [:show, :edit, :update, :destroy]
    before_action :set_by_hours_spent_id, only: [:approve, :for_admin]
    before_action :set_task

    # GET /hours_spents
    # GET /hours_spents.json
    def index
      if @task.project.complete?
        @hours = @task.hours_spents.personal.all
      else
        @hours = @task.hours_spents.billable.all
      end
    end

    # GET /hours_spents/1
    # GET /hours_spents/1.json
    def show
    end

    # GET /hours_spents/new
    def new
      @hour = @current_user.hours_spents.new
      authorize @hour
    end

    # GET /hours_spents/1/edit
    def edit
      authorize @hour
    end

    # POST /hours_spents
    # POST /hours_spents.json
    def create
      @task         = Task.find(params[:task_id])
      @hour         = @current_user.hours_spents.new(hours_spent_params)
      @hour.task    = @task
      @hour.project = @task.project
      authorize @hour

      respond_to do |format|
        if @hour.save
          format.html { redirect_to @current_user, notice: 'Timer registert' }
          format.json { render action: 'show', status: :created,
                        location: @hour }
        else
          format.html { render action: 'new' }
          format.json { render json: @hour.errors,
                        status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /hours_spents/1
    # PATCH/PUT /hours_spents/1.json
    def update
      authorize @hour
      respond_to do |format|
        if @hour.update(hours_spent_params)
          format.html { redirect_to @hour.task,
                        notice: 'Endringene er lagret' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @hour.errors,
                        status: :unprocessable_entity }
        end
      end
    end


    # DELETE /hours_spents/1
    # DELETE /hours_spents/1.json
    def destroy
      authorize @hour
      @hour.destroy
      respond_to do |format|
        format.html { redirect_to hours_spents_url }
        format.json { head :no_content }
      end
    end

    def approve
      authorize @hour
      @hour.approve!
      redirect_to user_hours_path(@hour.user, @hour.project,
        of_kind: params[:of_kind])
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_hours_spent
      @hour = HoursSpent.find(params[:id])
    end

    def create_billable_hour
      new_hour = HoursSpent.new(@hour.attributes
        .except('id', 'created_at', 'updated_at'))
      new_hour.update_attributes(hours_spent_params)
      new_hour.old_values = @hour.attributes
      new_hour.of_kind = :billable
      new_hour
    end





    def hours_spent_params
      params.require(:hours_spent).permit(:customer_id,
                                          :task_id,
                                          :user_id,
                                          :project_id,
                                          :overtime_50,
                                          :overtime_100,
                                          :runs_in_company_car,
                                          :km_driven_own_car,
                                          :change_reason,
                                          :toll_expenses_own_car,
                                          :supplies_from_warehouse,
                                          :piecework_hours,
                                          :hour, :description, :date)
    end

    def set_task
      @task = Task.find(params[:task_id])
    end

    def set_by_hours_spent_id
      @hour = HoursSpent.find(params[:hours_spent_id])
    end

  end
end
