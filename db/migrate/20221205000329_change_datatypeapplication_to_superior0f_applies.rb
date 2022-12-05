class ChangeDatatypeapplicationToSuperior0fApplies < ActiveRecord::Migration[5.1]
  def change
    change_column :applies, :application_to_superior, :integer
  end
end
