require './lib/sentry'

class ResumesController < ApplicationController
  extend ::Sentry

  def show
    @resume = resume
  end
  sentry_on :show, :expect => [:resume], :if_not => :handle_username_not_found

  def handle_username_not_found
    flash.now[:warning] = "The specified username does not appear to exist"
    redirect_to root_url
  end

  protected
  def resume
    ResumeRepository.find(username)
  end

  def username
    params[:username]
  end

end
