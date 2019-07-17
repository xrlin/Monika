module ApplicationHelper
  def date_str datetime
    datetime.strftime '%Y-%m-%d'
  end
end
