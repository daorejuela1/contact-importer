class CsvMapperController < ApplicationController
  before_action :get_csv_upload, only: :new

  def new
  end

  private
  def csv_upload_params 
    params.require(:csv_upload).permit(:id)
  end

  def get_csv_upload
    @csv_upload = current_user.csv_uploads.find(params[:id])
  end
end
