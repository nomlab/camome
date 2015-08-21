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
end
