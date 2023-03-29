class ChangeDataTitleToWorkedOn < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :worked_on, :datetime
  end
end
