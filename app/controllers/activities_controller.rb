class ActivitiesController < ApplicationController
  load_and_authorize_resource except: :create

  has_scope :find_by_date, using: :started_at

  respond_to :html

  def index
    begin
      @activity = Activity.new

      if params[:activity] and params[:activity][:starts_at] and !params[:activity][:starts_at].nil?
        @paginate_activities = Activity.find_by_activity_date(params[:activity][:starts_at]).page(params[:page]).per(5)
      else
        @paginate_activities = Activity.page(params[:page]).per(5).order("starts_at ASC")
      end

      activities_json
    rescue Exception => e
      puts e
    end

    @activities = Activity.all
    respond_to do |format|
      format.html
      format.json { render :json => @activities }
    end
  end

  def show
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @activity }
    end
  end

  def new
    @activity = Activity.new
    @activity_types = ActivityType.all
    @activity.starts_at = params[:current_date]
  end

  def create
    begin
      @activity = Activity.new(activity_params)

      respond_to do |format|
        if @activity.save!
          format.html { redirect_to calendars_path, :notice => 'Activity was successfully created.' }
          format.json { render :json => @activity, :status => :created, :location => @activity }
        else
          flash[:notice] = "Activity type can't save"
          format.html { render action: "new" }
          format.json { render json: @activity.errors, status: :unprocessable_entity }
        end
      end  
    rescue Exception => e
      puts e
    end
  end

  def edit
    @activity = Activity.find(params[:id])
    @activity_types = ActivityType.all
  end

  def update
    begin
      @activity = Activity.find(params[:id])

      respond_to do |format|
        if @activity.update_attributes!(activity_params)
          format.html { redirect_to calendars_path, :notice => 'Activity was successfully edited.' }
          format.json { render json: @activity, status: :created, location: @activity }
        else
          redirect_to :back
        end
      end  
    rescue Exception => e
      puts e
    end
  end

  def destroy
    # puts "======================================"
    @activity = Activity.find(params[:id])
    @activity.destroy

    puts "======================================"
    puts URI(request.referer).path.split('/')[1]
    puts "======================================"

    respond_to do |format|
      format.html { redirect_to calendars_path, :notice => 'Activity was successfully deleted.' }
      format.json { render json: @activity, status: :created, location: @activity }
    end
    # end   
  end

  private    
    def activity_params
      params.require(:activity).permit(:starts_at, :note, :activity_type_uuid)
    end
end