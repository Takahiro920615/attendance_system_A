class RenameApplicationContentColumnToApplies < ActiveRecord::Migration[5.1]
  def change
    rename_column :applies, :application_content, :one_month_request_status
  end
end
