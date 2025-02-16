class LaborsController < ApplicationController
  load_and_authorize_resource except: :create
  
  add_breadcrumb "All Labors", :labors_path

  def index
    @labors = Labor.all
  end
  
  def show
    @labor = Labor.find(params[:id])
  end

  def new
    begin
      @labor = Labor.new
      @projects = Project.all
      respond_to do |format|
        format.html
        format.json { render json: @projects }
      end
    rescue Exception => e
      puts e
    end
  end

  def create
    begin
      @labor = Labor.new(labor_params)

      if @labor.save
        create_log current_user.uuid, "Created New Labor", @labor
        flash[:notice] = "Labor saved successfully."
        redirect_to labors_path
      else
        flash[:notice] = "Labor can't be saved."
        render "new"
      end
    rescue Exception => e
      puts e
    end
  end

  def edit
    @labor = Labor.find(params[:id])
    @labors = Labor.all
    add_breadcrumb @labor.name, :edit_labor_path
  end

  def update
    begin
      @labor = Labor.find(params[:id])

      if @labor.update_attributes(labor_params)
        if params[:labor][:active] == "false"
          create_log current_user.uuid, "Deactivated Labor", @labor
        elsif params[:labor][:active] == "true"
          create_log current_user.uuid, "Activated Labor", @labor
        end

        if params[:labor][:active] == "1" or params[:labor][:active] == "0"
          create_log current_user.uuid, "Updated Labor", @labor  
        end 
        flash[:notice] = "Labor updated successfully"
        redirect_to labors_path
      else
        flash[:notice] = "Labor can't be saved"
        render "edit"
      end
    rescue Exception => e
      puts e
    end
  end

  def projects
    begin
      projects = Project.where("name like ?", "%#{params[:q]}%")

      respond_to do |format|
        format.html
        format.json { render json: projects.map { |project| { id: project.id, text: project.name }}}
      end
    rescue Exception => e
      puts e
    end
  end

  def labors
    begin
      labors = Labor.where("name like ?", "%#{params[:q]}%")

      respond_to do |format|
        format.html
        format.json { render json: labors.map { |labor| { id: labor.id, text: labor.name }}}
      end
    rescue Exception => e
      puts e
    end
  end

  def get_labor_email
    @labor_email = Labor.find_by_uuid(params[:labor_uuid])
    render :json => @labor_email
  end

  private
  def labor_params
    params.require(:labor).permit(:name, :position_id, :gender, :phone, :email, :address, :manager_uuid, :note, :selected, :active)
  end
end
