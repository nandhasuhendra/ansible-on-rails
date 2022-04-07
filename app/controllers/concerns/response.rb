module Response
  def render_json(data, status = :ok, include = nil)
    render json: data, status: status, include: include
  end
end
