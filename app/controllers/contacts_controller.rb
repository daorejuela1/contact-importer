class ContactsController < ApplicationController
  before_action :check_mapped_data, only: [:import]
  before_action :authenticate_user!

  def index
    @pagy, @contacts = pagy(Contact.all)
  end

  def new

  end

  def import
    
  end

  private

  def col_clean
    params.compact_blank
  end

  def check_mapped_data
    mapped_data = col_clean.select { |key, value| key.to_s.match(/^col\-\d+/)  }.to_unsafe_h
    if mapped_data.size != 6 || mapped_data.values.size != mapped_data.values.uniq.size
      redirect_to request.referer, alert: "You have to only pick one of each"
    end
  end
end
