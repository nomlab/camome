class MailController < ApplicationController
  def new
    @mail = Clam.find(params[:clam_id]).dup
  end
end
