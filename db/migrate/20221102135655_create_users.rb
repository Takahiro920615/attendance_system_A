class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :password_digest
      t.datetime :designated_work_start_time
      t.datetime :designated_work_end_time
      t.boolean :superior
      t.boolean :superior
      t.boolean :admin

      t.timestamps
    end
  end
end
