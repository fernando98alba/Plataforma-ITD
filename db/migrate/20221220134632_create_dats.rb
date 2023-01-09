class CreateDats < ActiveRecord::Migration[7.0]
  def change
    create_table :dats do |t|
      t.string :name

      t.timestamps
    end
  end
end
