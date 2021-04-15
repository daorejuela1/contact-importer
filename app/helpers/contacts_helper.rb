module ContactsHelper
  def date_parser(date)
    date = Date._parse(date)
    "#{date[:year]} #{date[:mon]} #{date[:mday]} "
  end

  def show_credit_card(card)
    "* #{card[-4..-1]}"
  end

  def error_listing(error)
    error_list = eval(error)
    code = "<ul>"
    concat code.html_safe
    error_list.each do |data|
      code = "<li>"
      concat code.html_safe
      concat data
      code = "</li>"
      concat code.html_safe
    end
    code = "</ul>"
    concat code.html_safe
  end
end
