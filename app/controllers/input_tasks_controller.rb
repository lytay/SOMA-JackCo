class InputTasksController < ApplicationController
	load_and_authorize_resource except: :create

	add_breadcrumb "All InputTasks", :input_tasks_path

  has_scope :planting_project_id

  def index
    @input_tasks = InputTask.order('updated_at DESC')
  end

  def new
    begin
      @input_task = InputTask.new
      # project_uuid = WarehouseType.find_by_name("Project Warehouse").uuid
      # @warehouses = Warehouse.where("warehouse_type_uuid = ? and active = ?", project_uuid, true)
      # @farms_name = Block.select("uuid, name, farm_id")

      # @machineries = Machinery.select("uuid, name")
      @materials = Material.select("uuid, name")

    rescue Exception => e
      puts e
    end
  end

  def new_input_task_from_map
    @input_task = InputTask.new
    project_uuid = WarehouseType.find_by_name("Project Warehouse").uuid
    @warehouses = Warehouse.where("warehouse_type_uuid = ? and active = ?", project_uuid, true)
    @block = Block.find_by(uuid: params[:block_id])
    @farm_block = @block.farm.name
  end

  def create
    begin
      @input_task = InputTask.new(input_task_params)
      input_task_end_date = @input_task.end_date
      
      # project_uuid = WarehouseType.find_by_name("Project Warehouse").uuid
      # @warehouses = Warehouse.where("warehouse_type_uuid = ? and active = ?", project_uuid, true)
      # @farms_name = Block.select("uuid, name, farm_id")

      # @machineries = Machinery.select("uuid, name")
      @materials = Material.select("uuid, name")

        # Start Select Material 
        if params[:materials].present?              
          @material_ids = params[:materials]
          @warehouses_of_material = params[:warehouses_of_material]
          @qty_of_material = params[:material_qtys_of_material]
          indexs = 0
          puts "+++++++++++++++++++++++++++ material_ids ++++++++++++++++++++++++++++++"
          puts @material_ids

          @material_ids.split(",").each do |material_id|
            unless material_id.empty?
              puts material_id
              puts "================= Input task UUID =============="
              puts @input_task.uuid
              puts "================= Warehouse_of_material '" + indexs.to_s + "'==========="
              puts warehouse_of_material = @warehouses_of_material[indexs]
              puts "================= Quantity_of_material '" + indexs.to_s + "'==========="
              puts qty_of_material = @qty_of_material[indexs]
              puts "============================================"
              indexs += 1

              if warehouse_of_material.present?
                @warehouse_material_amount = WarehouseMaterialAmount.find_by(warehouse_uuid: warehouse_of_material, material_uuid: material_id)
                puts "====================== Amount1 =========================="
                puts total_in_stock = @warehouse_material_amount.amount

                puts "============ Remain In Stock1 ============"
                puts remain_in_stock = total_in_stock - qty_of_material.to_f
                
                if total_in_stock >= qty_of_material.to_f

                  if @input_task.save

                    create_log current_user.uuid, "Created New Input Task", @input_task

                    InputUseMaterial.create(input_id: @input_task.uuid, material_id: material_id, warehouse_id: warehouse_of_material, material_amount: qty_of_material.to_f)
                    @warehouse_material_amount.update_attributes!(amount: remain_in_stock)

                  else
                    flash[:notice] = "Input Task can't be saved"
                    render 'new'
                  end

                
                else
                  flash[:notice] = "Suggested quantity exceeds the stock quantity"
                  render 'new' 
                end
              else
                flash[:notice] = "Make sure warehouse of material is selected!"
                render 'new'
              end
  
            end
          end
        else
          flash[:notice] = "Material is required"
          puts "No material_id"
          render 'new'
        end
        #End Select Material

        # Start Select Equipment
        if params[:equipments].present?               
          @equipment_ids = params[:equipments]
          index_equipment = 0
          puts "+++++++++++++++++++++++++++ equipment_ids ++++++++++++++++++++++++++++++"
          puts @equipment_ids

          @equipment_ids.split(",").each do |equipment_id|
            unless equipment_id.empty?
              puts equipment_id
              puts "================= Input task UUID =============="
              puts @input_task.uuid
              puts "============================================"
              index_equipment += 1

                InputUseEquipment.create(input_id: @input_task.uuid, equipment_id: equipment_id)             
               
            end
          end
        else
          puts "No equipment_id"
          # render 'new'
        end
        #End Select Equipment

        # Start Select Machinery               
        @machinery_ids = params[:machineries]
        @warehouses_of_machinery = params[:warehouses_of_machinery]
        @materials_of_machinery = params[:materials_of_machinery]
        @qty_of_machinery = params[:material_qtys_of_machinery]
        index = 0
        
        if params[:machineries].present?
          @machinery_ids.split(",").each do |machinery_id|
            unless machinery_id.empty?
              puts "================= Input task UUID =============="
              puts @input_task.uuid
              puts "================= Warehouses_of_machinery '" + index.to_s + "'==========="
              warehouse = @warehouses_of_machinery[index]
              puts "================= Materials_of_machinery '" + index.to_s + "'==========="
              material = @materials_of_machinery[index]
              puts "================= Quantity_material_of_machinery '" + index.to_s + "'==========="
              puts qty = @qty_of_machinery[index]
              puts "============================================"
              index += 1

              # Make sure Warehouse and Material of each machineries are selected
              if material.present? 
                @warehouse_material_amount = WarehouseMaterialAmount.find_by(warehouse_uuid: warehouse, material_uuid: material)
                puts "====================== Amount =========================="
                puts total_in_stock = @warehouse_material_amount.amount

                puts "============ Remain In Stock ============"
                puts remain_in_stock = total_in_stock - qty.to_f
                puts "========================================="
                @machinery = Machinery.find_by_uuid(machinery_id)
                
                if total_in_stock >= qty.to_f

                    @machinery.update_attributes!(availabe_date: input_task_end_date)
                    InputUseMachinery.create(input_id: @input_task.uuid, machinery_id: machinery_id, warehouse_id: warehouse, material_id: material, material_amount: qty.to_f)
                    @warehouse_material_amount.update_attributes!(amount: remain_in_stock)             
                
                else
                  flash[:notice] = "Suggested quantity exceeds the stock quantity"
                  render 'new' 
                end
              # else
              #   flash[:notice] = "Make sure warehouse and material are selected!"
              #   render 'new'
              end

            end

          end

        else
          puts "No machinery_id"
        end
        #End Select Machinery

      flash[:notice] = "Input Task saved successfully"
      redirect_to input_tasks_path   

    rescue Exception => e
      puts e
    end
  end

  def show
    @input_task = InputTask.find(params[:id])
  end

  private
  def input_task_params
    params.require(:input_task).permit(:name, :start_date, :end_date, :farm_id, :zone_id, :area_id, :block_id, :planting_project_id, :tree_amount, :labor_id, :reference_number, :note, :created_by)
  end

end
