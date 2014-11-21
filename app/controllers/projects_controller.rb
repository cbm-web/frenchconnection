class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, 
                                     :hours_registered, :complete]

  # GET /projects
  # GET /projects.json
  def index
    @departments        = @current_user.project_departments
    @starred_projects   = Project.where(user: @current_user, starred: true, 
                                        complete: false)
    @starred_customers  = Customer.where(starred: true)
    @completed_projects = Project.where(user: @current_user, complete: true)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        @current_user.favorites << @project
          .set_as_favorite if params[:project][:starred].present?
        format.html { redirect_to @project,
                      notice: 'Prosjektet ble lagret' }
        format.json { render action: 'show', status: :created, 
                      location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, 
                      status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        @current_user.favorites << @project
          .set_as_favorite if params[:project][:starred].present?
        format.html { redirect_to @project, 
                      notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, 
                      status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  # POST /projects/1
  # POST /projects/1.json
  def complete
    @project.complete!
    CompleteProjectWorker.perform_async(@project.id)
    respond_to do |format|
      format.html { redirect_to customer_projects_url(@project.customer) }
      format.json { head :no_content }
    end
  end

  def hours_registered
    @search           = @project.hours_spents.search
    @hours_registered = @search.result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:project_number, 
                                      :attachment,
                                      :billing_address, 
                                      :customer_id,
                                      :customer_reference, 
                                      :comment, 
                                      :delivery_address, 
                                      :due_date,
                                      :description,
                                      :execution_address, 
                                      :name, 
                                      :department_id,
                                      :starred,
                                      :start_date,
                                      :company_id
                                     )
    end
end
