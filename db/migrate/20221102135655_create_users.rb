class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :password_digest
      t.datetime :designated_work_start_time, default: "9:00"
      t.datetime :designated_work_end_time, default: "18:00"
      t.boolean :superior
      t.boolean :superior
      t.boolean :admin

      t.timestamps
    end
  end
end
