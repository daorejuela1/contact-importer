module ContactsHelper
  def date_parser(date)
    date = Date._parse(date)
    "#{date[:year]} #{date[:mon]} #{date[:mday]} "
  end

  def show_credit_card(card)
    "* #{card[-4..-1]}"
  end
end
