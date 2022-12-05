class ChangeDatatypeApplicationContent0fApplies < ActiveRecord::Migration[5.1]
  def change
    change_column :applies, :application_content, :integer
  end
end
