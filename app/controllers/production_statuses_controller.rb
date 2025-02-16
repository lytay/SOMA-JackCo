class ProductionStatusesController < ApplicationController
  load_and_authorize_resource except: :create

  add_breadcrumb "All Production Statuses", :production_statuses_path
  
  def index
    begin
      @production_status = ProductionStatus.new

      if params[:production_status] and params[:production_status][:name] and !params[:production_status][:name].nil?
        @production_statuses = ProductionStatus.find_by_production_status_name(params[:production_status][:name]).page(params[:page]).per(session[:item_per_page])
      else
        @production_statuses = ProductionStatus.page(params[:page]).per(session[:item_per_page])
      end
    rescue Exception => e
      puts e
    end
  end

  def new
    begin
      @production_status = ProductionStatus.new
    rescue Exception => e
      puts e
    end
  end

  def create
    begin
      @production_status = ProductionStatus.new(production_status_params)

      if @production_status.save
        create_log current_user.uuid, "Created New Production Status", @production_status
        flash[:notice] = "Production Status type saved successfully"
        redirect_to production_statuses_path
      else
        flash[:notice] = "Production Status type can't be saved"
        render 'new'
      end
    rescue Exception => e
      puts e
    end
  end

  def edit
    begin
      @production_status = ProductionStatus.find(params[:id])
      add_breadcrumb @production_status.name, :edit_production_status_path
    rescue Exception => e
      puts e
    end
  end

  def update
    begin
      @production_status = ProductionStatus.find(params[:id])

      if @production_status.update_attributes(production_status_params)
        if params[:production_stage][:active] == "false"
          create_log current_user.uuid, "Deactivated Production Stage", @production_stage
        elsif params[:production_stage][:active] == "true"
          create_log current_user.uuid, "Activated Production Stage", @production_stage
        end

        if params[:production_stage][:active] == "1" or params[:production_stage][:status] == "0"
          create_log current_user.uuid, "Updated Production Stage", @production_stage  
        end
        flash[:notice] = "Production Status updated"
        redirect_to production_statuses_path
      else
        flash[:notice] = "Production Status can't be updated"
        render 'edit'
      end
    rescue Exception => e
      puts e
    end
  end
 
  private
  def production_status_params
    params.require(:production_status).permit(:name, :stage_id, :note, :active)
  end
end
