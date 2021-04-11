class CsvUploadsController < ApplicationController
  def new
    @csv_upload = CsvUpload.new()
  end
  
  def upload
    @csv_upload = current_user.csv_uploads.new(csv_params)
    if @csv_upload.valid?
      render "csv_mapper/new"
    else
      render :new
    end
  end

 private
  def csv_params
    if params[:csv_upload].present?
      params.require(:csv_upload).permit(:csv_file)
    end
  end
end
