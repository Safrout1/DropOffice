class FormsController < ApplicationController
	def show
    @user = User.find(params[:user_id])
    @form = @user.forms.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @form = @user.forms.new
  end

  def create
    @user = User.find(params[:user_id])
    @form = @user.forms.create(form_params)
    render :nothing => true
  end

  def update
    @user = User.find(params[:user_id])
    @form = @user.forms.create(form_params)
   
    if @form.update(form_params)
      redirect_to 'static_pages#home'
    end
  end

  private
  	def form_params
      params.require(:form).permit(:title, :content)
    end
end