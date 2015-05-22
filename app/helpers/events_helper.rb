module EventsHelper
  def arrange_date(sdate, edate)
    if (sdate.year == edate.year) && (sdate.month == edate.month) && (sdate.day == edate.day)
      return sdate.strftime("%Y-%m-%d %H:%M")
    else
      return sdate.strftime("%Y-%m-%d %H:%M")
    end
  end
end
