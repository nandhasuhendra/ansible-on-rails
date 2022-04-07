class Api::V1::CredentialsController < ApplicationController
  def index
    @credential = Credential.all

    render_json( { data: @credential } )
  end

  def create
    @credential = Credential.new(set_params)

    if @credential.valid?
      @credential.file_name = set_credential

      @credential.save
      render_json({ data: "Credential is generated" })
    else
      render_json({ data: @credential.errors.messages }, :unprocessable_entity )
    end
  end

  def destroy
    @credential = Credential.find(params[:id])

    if @credential.destroy
      SSH::Credentials.new().delete(@credential.file_name)

      render_json({ data: "Credential is deleted" })
    else
      render_json({ data: @credential.errors.messages }, :unprocessable_entity )
    end
  end

  private
    def set_params
      senitizer(params.require(:credential).permit(:name, :key_type))
    end

    def set_credential
      SSH::Credentials.new(set_params).generate
    end
end
