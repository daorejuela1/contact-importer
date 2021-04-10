class ContactsController < ApplicationController
  def index
    @pagy, @contacts = pagy(Contact.all)
  end

end
