class Api::V1::DashboardsController < ApplicationController
  def index
    @users        = User.count
    @hosts        = Host.count
    @groups       = Group.count
    @credentials  = Credential.count
    @tasks        = Task.count
    @jobs         = Job.count

    render_json({ data: { users: @users, hosts: @hosts, groups: @groups, credentials: @credentials, tasks: @tasks, jobs: @jobs } })
  end
end
