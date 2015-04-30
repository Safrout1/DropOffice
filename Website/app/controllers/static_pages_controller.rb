class StaticPagesController < ApplicationController
  def home
    if current_user
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


end
