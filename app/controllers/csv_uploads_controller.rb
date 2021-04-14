class CsvUploadsController < ApplicationController
  def new
    @csv_upload = current_user.csv_uploads.new()
  end

  def index
    @pagy, @csv_files = pagy(current_user.csv_uploads.all)
  end
  
  def create
    csv_upload = current_user.csv_uploads.new(csv_params)
    if csv_upload.save
      redirect_to new_csv_mapper_path(id: csv_upload), notice: "File accepted"
    else
      render :new
    end
  end

  def destroy
    @csv_upload = current_user.csv_uploads.find(params[:id])
    redirect_to csv_uploads_path, notice: 'File deleted succesfully' if @csv_upload.destroy
  end

 private
  def csv_params
    if params[:csv_upload].present?
      params.require(:csv_upload).permit(:csv_file)
    end
  end
end
