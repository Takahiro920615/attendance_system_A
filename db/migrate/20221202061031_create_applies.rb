class CreateApplies < ActiveRecord::Migration[5.1]
  def change
    create_table :applies do |t|
      t.date :one_month
      t.string :application_to_superior
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
