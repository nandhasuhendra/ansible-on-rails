class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy,:renderer]

  def index
    @tasks = Task.all

    render_json({ data: @tasks })
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.create(set_params)

    if @task.valid?
      render_json({ data: @task })
    else
      render_json({ data: @task.errors.messages }, :unprocessable_entity)
    end
  end

  def show
    render_json({ data: @task })
  end

  def update
    if @task.update_attributes(set_params)
      render_json({ data: @task })
    else
      render_json({ data: @task.errors.messages }, :unprocessable_entity)
    end
  end

  def destroy
    if @task.destroy
      render_json({ data: @task })
    else
      render_json({ data: @task.errors.messages }, :unprocessable_entity)
    end
  end

  private
    def set_task
      @task = Task.find_by_id(params[:id])
    end

    def set_params
      senitizer(params.require(:task).permit(:name, :descriptions, :task, :task_file))
    end
end
