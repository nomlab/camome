module EventsHelper
  def arrange_date(sdate, edate)
    if (sdate.year == edate.year) && (sdate.month == edate.month) && (sdate.day == edate.day)
      return sdate.strftime("%Y-%m-%d %H:%M:%S") + " - " + edate.strftime("%H:%M:%S")
    else
      return sdate.strftime("%Y-%m-%d %H:%M:%S") + " - " + edate.strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
