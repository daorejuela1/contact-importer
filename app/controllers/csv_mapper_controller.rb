class CsvMapperController < ApplicationController
  before_action :get_csv_upload, only: :new
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordInvalid, with: :bad_file

  def new
  end

  private
  def csv_upload_params 
    params.require(:csv_upload).permit(:id)
  end

  def get_csv_upload
    @csv_upload = current_user.csv_uploads.find(params[:id])
  end

  def bad_file
    redirect_to request.referer, alert: "There's an error in the file"
  end
end
