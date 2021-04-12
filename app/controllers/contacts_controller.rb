class ContactsController < ApplicationController
  before_action :check_mapped_data, only: [:import]
  before_action :authenticate_user!

  def index
    @pagy, @contacts = pagy(Contact.all)
  end

  def new

  end

  def import
    file = CsvUpload.find_by_id(params[:csv_file_id])
    Contact.import_csv(file, @mapped_data, current_user)
    redirect_to contacts_path, notice: "Contacts uploadedc:"
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
