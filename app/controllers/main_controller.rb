class MainController < ApplicationController
  def index
    @pagy, @contacts = pagy(Contact.all)
  end
end
