class ChangeDatetypeworkedOn0fattendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :worked_on, :date
  end
end
