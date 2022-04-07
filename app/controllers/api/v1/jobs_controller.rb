class Api::V1::JobsController < ApplicationController
  before_action :set_job, only: [:show, :update, :destroy]
  after_action :renderer, only: [:create, :update], if: -> { response.successful? }

  def index
    @jobs = Job.all

    render_json({ data: @jobs })
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.create(set_params)

    if @job.valid?
      render_json({ data: @job })
    else
      render_json({ data: @job.errors.messages }, :unprocessable_entity)
    end
  end

  def show
    render_json({ data: @job })
  end

  def update
    if @job.update_attributes(set_params)
      render_json({ data: @job })
    else
      render_json({ data: @job.errors.messages }, :unprocessable_entity)
    end
  end

  def destroy
    if @job.destroy
      render_json({ data: @job })
    else
      render_json({ data: @job.errors.messages }, :unprocessable_entity)
    end
  end

  private
    def set_job
      @job = Job.find_by_id(params[:id])
    end

    def set_params
      senitizer(params.require(:job).permit(:name, :descriptions, :scheduler, :group_id, :task_id))
    end

    def renderer
      Ansible::Libs::RenderYaml.new(@job).from_task
    end
end
