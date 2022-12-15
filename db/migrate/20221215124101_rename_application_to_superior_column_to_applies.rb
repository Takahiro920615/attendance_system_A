class RenameApplicationToSuperiorColumnToApplies < ActiveRecord::Migration[5.1]
  def change
    rename_column :applies, :application_to_superior, :one_month_boss
  end
end
