class MailController < ApplicationController
  def new
    @mail = Clam.find(params[:clam_id]).dup
    @source_id = params[:clam_id]
  end
end
