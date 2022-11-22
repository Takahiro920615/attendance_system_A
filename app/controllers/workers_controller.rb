class WorkersController < ApplicationController
  def show
    worker = Worker.all
    @workers = worker.all.includes(:users,:attendances)
  end
end
