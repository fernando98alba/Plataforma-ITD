class AddPonderadorToDat < ActiveRecord::Migration[7.0]
  def change
    add_column :dats, :ponderador, :float
  end
end
