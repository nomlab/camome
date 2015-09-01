module ApplicationHelper
  def inbox_classes
    raw %(id="table"
      data-class="table table-hover table-bordered table-condensed"
      data-toggle="table"
      data-height="500"
      data-striped="true"
      data-sort-name="date"
      data-sort-order="desc")
  end

  def process_date(sdate, edate)
      if (sdate.year == edate.year) && (sdate.month == edate.month) && (sdate.day == edate.day)
        return sdate.strftime("%Y-%m-%d %H:%M")
      else
        return sdate.strftime("%Y-%m-%d %H:%M")
    end
  end
end
