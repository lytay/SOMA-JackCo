# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# run:
# rake db:seed
# ========== Create Roles ========== 
[
  {name: 'admin', note: 'Controlling all modules', label: 'Admin'},
  {name: 'top_manager', note: 'Can read all modules and download all reports', label: 'TOP Manager'},
  {name: 'officer', note: 'Can input all modules', label: 'Officer'},
  {name: 'it', note: 'Can edit all modules', label: 'IT'}
].each do |role|
  Role.create_with(note: role[:note], label: role[:label]).find_or_create_by(name: role[:name])
end

# ==========  Create UserGroup ========== 
[ 
  {name: "Administrator", note: "Controlling everything", active: true},
  {name: "Manager", note: "Controlling general tasks", active: true},
  {name: "Project Leader", note: "Controlling all projects", active: true},
  {name: "Data Entry", note: "Inputting data", active: true}
].each do |user_group|
  userg = UserGroup.create_with(note: user_group[:note], active: user_group[:active]).find_or_create_by(name: user_group[:name])
end

# ==========  Create Resource ========== 
[ 
  {name: 'User', note: 'Controlling users'},
  {name: 'Warehouse', note: 'Controlling warehouses'}
].each do |resource|
  res = Resource.create_with(note: resource[:note]).find_or_create_by(name: resource[:name])
end  

# ========== Create a User ========== 
user_group = UserGroup.create_with(note: "Controlling all resources", active: true).find_or_create_by(name: "Administrator")
user = User.create_with(password: "admin1234567890", password_confirmation: "admin1234567890", role: "admin").find_or_create_by(email: "admin@cltag.com")

user_group.users << user

# ========== Create Objects from UserGroup and Resource ========== 
user_group_admin = UserGroup.find_by_name("Administrator")
user_group_manager = UserGroup.find_by_name("Manager")
user_group_project_leader = UserGroup.find_by_name("Project Leader")
user_group_data_entry = UserGroup.find_by_name("Data Entry")

resource_user = Resource.find_by_name("User")
resource_warehouse = Resource.find_by_name("Warehouse")

# ========== Create Permissions ========== 
[ 
  {name: "Admin Permission on User", user_group_id: user_group_admin.uuid, resource_id:  resource_user.uuid, access_full: false, access_list: false, access_create: false, access_update: false, access_delete: false, active: true},
  {name: "Admin Permission on warehouse", user_group_id: user_group_admin.uuid, resource_id: resource_warehouse.uuid, access_full: false, access_list: false, access_create: false, access_update: false, access_delete: false, active: true},
  {name: "Manager Permission on User", user_group_id: user_group_manager.uuid, resource_id: resource_user.uuid, access_full: false, access_list: false, access_create: false, access_update: false, access_delete: false, active: true},
  {name: "Manager Permission on warehouse", user_group_id: user_group_manager.uuid, resource_id: resource_warehouse.uuid, access_full: false, access_list: false, access_create: false, access_update: false, access_delete: false, active: true},
  {name: "Project leader Permission on User", user_group_id: user_group_project_leader.uuid, resource_id: resource_user.uuid, access_full: false, access_list: false, access_create: false, access_update: false, access_delete: false, active: true},
  {name: "Project leader Permission on warehouse", user_group_id: user_group_project_leader.uuid, resource_id: resource_warehouse.uuid, access_full: false, access_list: false, access_create: false, access_update: false, access_delete: false, active: true},
  {name: "Data Entry Permission on User", user_group_id: user_group_data_entry.uuid, resource_id: resource_user.uuid, access_full: false, access_list: false, access_create: false, access_update: false, access_delete: false, active: true},
  {name: "Data Entry Permission on warehouse", user_group_id: user_group_data_entry.uuid, resource_id: resource_warehouse.uuid, access_full: false, access_list: false, access_create: false, access_update: false, access_delete: false, active: true},
].each do |permission|
  Permission.create_with(user_group_id: permission[:user_group_id], resource_id: permission[:resource_id], access_full: permission[:access_full], access_list: permission[:access_list], access_create: permission[:access_create], access_update: permission[:access_update], access_delete: permission[:access_delete], active: permission[:active]).find_or_create_by(name: permission[:name])
end

# ========== Create Projects ========== 
[ 
  { name: 'Jackfruit' },
  { name: 'Coconut' }
].each do |project|
  Project.find_or_create_by(name: project[:name])
end

# ========== Create Activity types ========== 
[ 
  { name: 'Tilling', note: 'Tilling trees', label: 'Tilling' },
  { name: 'Planting', note: 'Planting trees', label: 'Planting' },
  { name: 'Fertilizing', note: 'Fertilizing trees', label: 'Fertilizing' },
  { name: 'Harvesting', note: 'Harvesting products', label: 'Harvesting' }
].each do |activity_type|
  ActivityType.create_with(note: activity_type[:note], label: activity_type[:label]).find_or_create_by(name: activity_type[:name])
end

# ========== Create Stages ========== 
[ 
  { name: 'Stage 1: Nursery (age:1-4month)', period: '4 months', note: 'Phase 1: Seed (Nursery)', fruit_type: 'coconut' },
  { name: 'Stage 2: Planting', period: '45-50 days', note: 'Phase 1: Seed (Nursery)', fruit_type: 'coconut' },
  { name: 'Stage 3: Baby Coconut (age: 1-2 years)', period: '2 years', note: 'Phase 2: Plant Growing & Protection', fruit_type: 'coconut' },
  { name: 'Stage 4: Adult Coconut (Developing age: 3-4 years)', period: '2 years', note: 'Phase 2: Plant Growing & Protection', fruit_type: 'coconut' },
  { name: 'Stage 5: First Production (age: 5-7 years)', period: '3 years', note: 'Phase3: Production & Harvesting', fruit_type: 'coconut' },
  { name: 'Stage 6: Full Production (age: 8-15 years)', period: '8 years', note: 'Phase3: Production & Harvesting', fruit_type: 'coconut' },
  { name: 'Stage 7: Decreasing Production (age: 16-20 years)', period: '5 years', note: 'Phase3: Production & Harvesting', fruit_type: 'coconut' },
  { name: 'Seed Amount', period: 'unknown', note: 'Phase 1: Seed Grafting', fruit_type: 'jackfruit' },
  { name: 'Stage 1: Age 1-3 years', period: '1-3 years', note: 'Phase 2: Plant Growing & Protection', fruit_type: 'jackfruit'},
  { name: 'Stage 2: Age > 4 years', period: 'more than 4 years', note: 'Phase 2: Plant Growing & Protection', fruit_type: 'jackfruit'},
  { name: 'Stage 3: Age 5-15 years', period: '5-15 years', note: 'Phase 3: Harvesting', fruit_type: 'jackfruit'}
  
].each do |stage|
  Stage.create_with(period: stage[:period], note: stage[:note], fruit_type: stage[:fruit_type]).find_or_create_by(name: stage[:name])
end

# ========== Create Data for Pie Chart ========== 
[
  {name: 'Fertilizer', amount: 3000},
  {name: 'Small Tree', amount: 5000},
  {name: 'Workers', amount: 2000},
  {name: 'Fuel', amount: 10000}
].each do |testing_chart|
  TestingChart.create_with(amount: testing_chart[:amount]).find_or_create_by(name: testing_chart[:name])
end

# ========== Create Data for Bar Chart ========== 
[
  {element: 'January', amount: 40.49, bar_color: 'silver'},
  {element: 'February', amount: 20.49, bar_color: 'gold'},
  {element: 'March', amount: 20.49, bar_color: 'blue'},
  {element: 'April', amount: 20.49, bar_color: 'green'}
].each do |bar_chart|
  TestingWithBarChart.create_with(bar_color: bar_chart[:bar_color] ,amount: bar_chart[:amount]).find_or_create_by(element: bar_chart[:element])
end

# ========== Create Warehouse Types ========== 
[
  {name: 'Central Warehouse', note: 'It is the big warehouse.'},
  {name: 'Project Warehouse', note: 'It is the warehouse that is near the farms.'},
  {name: 'Finished Goods Warehouse', note: 'It is the warehouse that stock all yields harvest from the farms.'},
  {name: 'Nursery Warehouse', note: 'It is the plant nursery warehouse.'}
].each do |warehouse_type|
  WarehouseType.create_with(note: warehouse_type[:note]).find_or_create_by(name: warehouse_type[:name])
end

# ========== Create Transaction Statuses ========== 
[
  {name: 'Stock-in', note: 'Import into stock.'},
  {name: 'Stock-out', note: 'Export from stock.'},
  {name: 'Adjustment', note: 'Adjustment note'}
].each do |transaction_status|
  TransactionStatus.create_with(note: transaction_status[:note]).find_or_create_by(name: transaction_status[:name])
end

# ========== Create Planting Projects ========== 
[
  {project_name: 'Coconut'},
  {project_name: 'Jackfruit'},
  {project_name: 'Mango'},
  {project_name: 'Lemon'}
].each do |planting_project|
  PlantingProject.find_or_create_by(project_name: planting_project[:project_name])
end

# ========== Create Unit of Measurement ========== 
[
  {name: 'Unit', note: 'Unit of measurement for tree, amount of fruit,...'},
  {name: 'Kg', note: 'Unit of measurement for kilogram.'},
  {name: 'g', note: 'Unit of measurement for gram.'},
  {name: 'Litre', note: 'Unit of measurement for litre.'},
  {name: 'Ml', note: 'Unit of measurement for mili-litre.'}
].each do |unit_measure|
  UnitOfMeasurement.create_with(note: unit_measure[:note]).find_or_create_by(name: unit_measure[:name])
end

# ========== Create Material Categories ========== 
[
  {name: 'FERTILIZERS', note: 'Fertilizer note'},
  {name: 'PEST & INSECTICIDES', note: 'Pest and Insecticide note'},
  {name: 'FUNGICIDE', note: 'Fungicide note'},
  {name: 'HERBICIDE', note: 'Herbicide note'}
].each do |material_category|
  MaterialCategory.create_with(note: material_category[:note]).find_or_create_by(name: material_category[:name])
end
# ========== Create Farms ==========
[
  {name: 'Oroung Farm', location: 'Bati District, Takeo Province', latlong_farm: '11.333019, 104.864575'},
  {name: 'Chamkar Doung Farm', location: 'Bati District, Takeo Province', latlong_farm: '11.341900, 104.822941'},
  {name: 'Otarath Farm', location: 'Bati District, Takeo Province', latlong_farm: '11.336964, 104.830418'},
  {name: 'Kapaet Farm', location: 'Bati District, Takeo Province', latlong_farm: '11.336681, 104.858414'}
].each do |farm|
  Farm.create_with(location: farm[:location], latlong_farm: farm[:latlong_farm]).find_or_create_by(name: farm[:name])
end
# ========== Create Blocks for Chamkar Doung Farm ==========
coconut_farm = Farm.find_by_name('Chamkar Doung Farm')
oroung_farm= Farm.find_by_name('Oroung Farm')
coconut_planting_project=PlantingProject.find_by_project_name('Coconut')
jackfruit_planting_project=PlantingProject.find_by_project_name('Jackfruit')
# ========== Create Blocks for Oroung Farm ========== 
[
  {name: 'Block A1', surface: 4, shape_lat_long: '[[11.34228844248775,104.8173368444448],[11.34222380000888,104.8171604557845],[11.3419655618982,104.8170819933822],[11.34197186349495,104.8169376349896],[11.34152765634626,104.8168564506022],[11.34152565378016,104.8161860309814],[11.34072187781601,104.8161618977276],[11.34073587728222,104.8166945670797],[11.34083425409179,104.8171092601984],[11.34104359934694,104.8174874094787],[11.34114577172203,104.8181746246259],[11.34214745471061,104.8184887833901],[11.34225258745473,104.8181561580298],[11.34287072363673,104.8182904066128],[11.34309297859914,104.8175375089032],[11.34228844248775,104.8173368444448]]', location_lat_long: '11.341644, 104.817429', rental_status: 0, status: 0, planting_project_id: coconut_planting_project.uuid, farm_id: coconut_farm.uuid, tree_amount: 150},
  {name: 'Block A2', surface: 4, shape_lat_long: '[[11.34120932973546,104.8183803286982],[11.34112138334435,104.8184150176988],[11.34092905012725,104.8183922652106],[11.34081065229375,104.8186381489472],[11.34173900706889,104.8191704886344],[11.34189976470813,104.8186003149401],[11.34120932973546,104.8183803286982]]', location_lat_long: '11.341650, 104.818817', rental_status: 0, status: 0, planting_project_id: coconut_planting_project.uuid, farm_id: coconut_farm.uuid, tree_amount: 150},
  {name: 'Block B1', surface: 4, shape_lat_long: '[[11.3426925242798,104.8245537931735],[11.34166404238365,104.8242249418216],[11.34103896398493,104.825357008084],[11.34006824571877,104.8263752710081],[11.340572376197,104.8268078894533],[11.3426925242798,104.8245537931735]]', location_lat_long: '11.341343, 104.825563', rental_status: 0, status: 0, planting_project_id: coconut_planting_project.uuid, farm_id: coconut_farm.uuid, tree_amount: 150},
  {name: 'Block A', surface: 4, shape_lat_long: '[[11.3406183375262,104.8220830750786],[11.34048569682613,104.8225603305345],[11.34077415662084,104.8227130665497],[11.34076394170529,104.8228339709717],[11.34123410683447,104.8228804399975],[11.34177497649118,104.8230441480793],[11.34194189011643,104.8223583223038],[11.3406183375262,104.8220830750786]]', location_lat_long: '11.341247, 104.822549', rental_status: 0, status: 0, planting_project_id: jackfruit_planting_project.uuid, farm_id: coconut_farm.uuid, tree_amount: 150},
  {name: 'Block B3', surface: 4, shape_lat_long: '[[11.3380549468293,104.8240472203577],[11.33787545358411,104.8246042945429],[11.34005476537737,104.8263622974383],[11.34102333706613,104.8253242989032],[11.3380549468293,104.8240472203577]]', location_lat_long: '11.339502, 104.825091', rental_status: 0, status: 0, planting_project_id: coconut_planting_project.uuid, farm_id: coconut_farm.uuid, tree_amount: 150},
  {name: 'Block C1', surface: 4, shape_lat_long: '[[11.34024659610298,104.8271098186776],[11.34060069812196,104.8268441183729],[11.33498493139846,104.8223869773665],[11.33533785551793,104.8213092938915],[11.33489589388238,104.8211246009857],[11.33447832386705,104.822553696527],[11.34024659610298,104.8271098186776]]', location_lat_long: '11.337009, 104.824281', rental_status: 0, status: 0, planting_project_id: coconut_planting_project.uuid, farm_id: coconut_farm.uuid, tree_amount: 150},
  {name: 'Block C1', surface: 4, shape_lat_long: '[[11.34024659610298,104.8271098186776],[11.34060069812196,104.8268441183729],[11.33498493139846,104.8223869773665],[11.33533785551793,104.8213092938915],[11.33489589388238,104.8211246009857],[11.33447832386705,104.822553696527],[11.34024659610298,104.8271098186776]]', location_lat_long: '11.337009, 104.824281', rental_status: 0, status: 0, planting_project_id: coconut_planting_project.uuid, farm_id: coconut_farm.uuid, tree_amount: 150}
].each do |block|
  Block.create_with(surface: block[:surface], shape_lat_long: block[:shape_lat_long], location_lat_long: block[:location_lat_long], rental_status: block[:rental_status], status: block[:status], planting_project_id: block[:planting_project_id], farm_id: block[:farm_id], tree_amount: block[:tree_amount]).find_or_create_by(name: block[:name])
end
[
  {name: 'Block A1', surface: 4, shape_lat_long: '[[11.33311439628769,104.863074517573],[11.33303836909471,104.8645267817349],[11.33419647990755,104.8649847944117],[11.33421414894168,104.8637520663834],[11.33311439628769,104.863074517573]]', location_lat_long: '11.333647, 104.864061', rental_status: 0, status: 0, planting_project_id: jackfruit_planting_project.uuid, farm_id: oroung_farm.uuid, tree_amount: 150},
  {name: 'Block A2', surface: 4, shape_lat_long: '[[11.3324478315573,104.8626668657542],[11.33237585061472,104.8641630720923],[11.3326473207779,104.864211450934],[11.33269227121635,104.8643861577813],[11.33301753047669,104.8645186365714],[11.33307675273036,104.8630691210814],[11.3324478315573,104.8626668657542]]', location_lat_long: '11.332858, 104.863621', rental_status: 0, status: 0, planting_project_id: jackfruit_planting_project.uuid, farm_id: oroung_farm.uuid, tree_amount: 150},
  {name: 'Block A3', surface: 4, shape_lat_long: '[[11.33259193166157,104.864971260675],[11.33255103799581,104.8653026157271],[11.33242918270696,104.8653124252415],[11.33241636992461,104.8656656733321],[11.33254475167357,104.8657207093244],[11.33256256387976,104.8659044565683],[11.33293397308591,104.865911430465],[11.33298004181689,104.8650429908266],[11.33259193166157,104.864971260675]]', location_lat_long: '11.332724, 104.865494', rental_status: 0, status: 0, planting_project_id: jackfruit_planting_project.uuid, farm_id: oroung_farm.uuid, tree_amount: 150},
  {name: 'Block B1', surface: 4, shape_lat_long: '[[11.33360091727752,104.8648150209845],[11.33354905571442,104.8654192999268],[11.3334329480574,104.8653970369069],[11.33344462261639,104.8651619590034],[11.33304147819797,104.8650389585108],[11.33295439699371,104.8665397635701],[11.33419145854843,104.8669987532221],[11.33419096118103,104.8650500301504],[11.33360091727752,104.8648150209845]]', location_lat_long: '11.333687, 104.865956', rental_status: 0, status: 0, planting_project_id: jackfruit_planting_project.uuid, farm_id: oroung_farm.uuid, tree_amount: 150},
  {name: 'Block B2', surface: 4, shape_lat_long: '[[11.33297236650325,104.8665889012607],[11.33290609918916,104.8681085700067],[11.33318887235587,104.8681464909949],[11.33319890176019,104.8682790524576],[11.33418809491344,104.8682950611748],[11.334192036974,104.8670305625423],[11.33297236650325,104.8665889012607]]', location_lat_long: '11.333592, 104.867592', rental_status: 0, status: 0, planting_project_id: jackfruit_planting_project.uuid, farm_id: oroung_farm.uuid, tree_amount: 150},
  {name: 'Block C1', surface: 4, shape_lat_long: '[[11.33286716554191,104.8683328834296],[11.33281790971606,104.8710704750993],[11.33378832634235,104.8710829491849],[11.33378833233909,104.8709496668367],[11.33371753280396,104.870900716156],[11.33378844867719,104.868480493603],[11.33414409924556,104.8684593112575],[11.33414926227775,104.8683328873223],[11.33286716554191,104.8683328834296]]', location_lat_long: '11.333392, 104.869861', rental_status: 0, status: 0, planting_project_id: jackfruit_planting_project.uuid, farm_id: oroung_farm.uuid, tree_amount: 150},
  {name: 'Block C2', surface: 4, shape_lat_long: '[[11.3322750761453,104.8693063700752],[11.33222632314401,104.8708299466653],[11.33250555605274,104.8708585729013],[11.33257165108565,104.8693194724903],[11.3322750761453,104.8693063700752]]', location_lat_long: '11.332514, 104.870210', rental_status: 0, status: 0, planting_project_id: jackfruit_planting_project.uuid, farm_id: oroung_farm.uuid, tree_amount: 150},
  {name: 'Block C3', surface: 4, shape_lat_long: '[[11.33327767462742,104.8714486012229],[11.33326530072757,104.8722167315754],[11.33389699046733,104.8722127064837],[11.33389957250136,104.871824944219],[11.33373153189838,104.8717984056386],[11.33375157922602,104.8714607584913],[11.33327767462742,104.8714486012229]]', location_lat_long: '11.333539, 104.871830', rental_status: 0, status: 0, planting_project_id: jackfruit_planting_project.uuid, farm_id: oroung_farm.uuid, tree_amount: 150}
].each do |block|
  Block.create_with(surface: block[:surface], shape_lat_long: block[:shape_lat_long], location_lat_long: block[:location_lat_long], rental_status: block[:rental_status], status: block[:status], planting_project_id: block[:planting_project_id], farm_id: block[:farm_id], tree_amount: block[:tree_amount]).find_or_create_by(name: block[:name])
end