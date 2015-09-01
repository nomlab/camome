class MailController < ApplicationController
  def new
    @mail = Clam.find(params[:clam_id]).dup
    @parent_id = params[:clam_id]
  end
end
