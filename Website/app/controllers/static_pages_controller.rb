class StaticPagesController < ApplicationController
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

  def contact
  end

  def thanks
  end

end
