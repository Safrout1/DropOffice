class StaticPagesController < ApplicationController
  def list
  end

  def home
    if logged_in?
    redirect_to current_user
    end
  end

  def help
  end
  
  def about
  end

  def texteditor
  end

  def docs
  end

  def thanks
  end

  def contact
  end

end
