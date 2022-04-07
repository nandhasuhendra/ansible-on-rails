class Api::V1::HostsController < ApplicationController
  before_action :set_host, only: [:show, :update, :destroy]
  after_action :renderer, only: [:create, :update], if: -> { response.successful? }

  def index
    @hosts = Host.all

    render_json({ data: @hosts })
  end

  def new
    @host = Host.new
  end

  def create
    @host = Host.create(set_params)

    if @host.valid?
      render_json({ data: @host })
    else
      render_json({ data: @host.errors.messages }, :unprocessable_entity)
    end
  end

  def show
    render_json({ data: @host })
  end

  def update
    if @host.update_attributes(set_params)
      render_json({ data: @host })
    else
      render_json({ data: @host.errors.messages }, :unprocessable_entity)
    end
  end

  def destroy
    if @host.destroy
      render_json({ data: @host })
    else
      render_json({ data: @host.errors.messages }, :unprocessable_entity)
    end
  end

  private
    def set_host
      @host = Host.find_by_id(params[:id])
    end

    def set_params
      senitizer(params.require(:host).permit(:name, :ip_address))
    end

    def renderer
      Ansible::Libs::RenderYaml.new(@host).from_host
    end
end
