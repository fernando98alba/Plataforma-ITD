class CreateCuestionarios < ActiveRecord::Migration[7.0]
  def change
    create_table :cuestionarios do |t|
      t.string :min_description
      t.string :max_description
      t.string :verifier
      
      t.timestamps
    end
  end
end
