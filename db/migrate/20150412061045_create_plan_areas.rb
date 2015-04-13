class CreatePlanAreas < ActiveRecord::Migration
  def change
    create_table :plan_areas, id: false do |t|
      t.string :uuid, limit: 36, primary: true, null: false
      t.string :plan_production_status_id, limit: 36, null: false
      t.string :block_id, limit: 36, null: false
      t.integer :tree_amount, null: false

      t.timestamps
    end
  end
end
