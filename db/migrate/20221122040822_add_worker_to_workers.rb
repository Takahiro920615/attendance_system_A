class AddWorkerToWorkers < ActiveRecord::Migration[5.1]
  def change
    add_column :workers, :worker, :string
  end
end
