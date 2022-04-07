class Api::V1::GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :destroy]
  after_action :render_group, only: [:create, :update]
  after_action :render_job, only: [:update]

  def index
    @groups = Group.includes(:hosts, :group_members).all

    render json: @groups, status: :ok, include: { group_members: { include: :host } }
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.create(set_params)

    if @group.valid?
      render_json({ data: @group })
    else
      render_json({ data: @group.errors.messages }, :unprocessable_entity)
    end
  end

  def show
    render_json({ data: @group })
  end

  def update
    if @group.update_attributes(set_params)
      render_json({ data: @group })
    else
      render_json({ data: @group.errors.messages }, :unprocessable_entity)
    end
  end

  def destroy
    if remove_from_host
      @group.destroy
      
      render_json({ data: @group })
    else
      render_json({ data: @group.errors.messages }, :unprocessable_entity)
    end
  end

  def setup
    if copy_to_host
      render_json({ data: @result })
    else
      render_json({ data: "Setup error" }, :unprocessable_entity)
    end
  end

  private
    def set_group
      @group = Group.find_by_id(params[:id])
    end

    def set_params
      senitizer(params.require(:group).permit(:name, :descriptions, :credential_id, host_ids: []))
    end

    def render_group
      @group = Group.includes(:hosts).find_by_id(@group.id)

      Ansible::Libs::RenderYaml.new(@group).from_group
    end

    def render_job
      jobs = Job.includes(:group).where(group_id: params[:id])

      jobs.each do |job|
        @job = Job.find_by_id(job.id)

        Ansible::Libs::RenderYaml.new(@job).from_task
      end
    end

    def copy_to_host
      @group        = Group.includes(:hosts).find_by_id(params[:id])
      @result       = []

      unless @group.hosts.nil?
        @group.hosts.each do |host|
          result = SSH::Command.new(
            "ansible",
            "123123",
            "",
            host.ip_address,
            host.port,
            @group.credential.file_name
          ).copy_id

          @group.group_members.where(host_id: host.id).update(build_status: result[:status])
          @result << result
        end
      else
        false
      end
    end

    def remove_from_host
      unless @group.hosts.nil?
        @group.hosts.each do |host|
          SSH::Command.new(
            "ansible",
            "123123",
            "",
            host.ip_address,
            host.port,
            @group.credential.file_name
          ).copy_id
        end
      else
        false
      end
    end
end
