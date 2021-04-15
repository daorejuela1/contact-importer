class ContactsController < ApplicationController
  before_action :check_mapped_data, only: [:import]
  before_action :authenticate_user!

  def index
    @pagy, @contacts = pagy(current_user.contacts.all)
    @pagy_errors, @contact_errors = pagy(current_user.contact_errors.all, page_param: :page_error)
  end

  def new

  end

  def import
    file = CsvUpload.find_by_id(params[:id])
    ContactWorkerJob.perform_async(params[:id], @mapped_data, current_user.id)
    redirect_to contacts_path, notice: "File has ben added to queue"
  end

  private

  def col_clean
    params.compact_blank
  end

  def check_mapped_data
    @mapped_data = col_clean.select { |key, value| key.to_s.match(/^col\-\d+/)  }.to_unsafe_h
    if @mapped_data.size != 6 || @mapped_data.values.size != @mapped_data.values.uniq.size
      redirect_to request.referer, alert: "You have to only pick one of each"
    end
  end

  def import_params
    params.require(:contact).permit(:csv_file)
  end
end
