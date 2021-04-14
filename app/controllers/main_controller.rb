class MainController < ApplicationController
  def index
    @pagy, @contacts = pagy(Contact.all)
    respond_to do |format|
      format.html
      format.csv { send_data Contact.generate_csv, filename: "Contacts-#{Date.today}.csv" }
    end
  end
end
