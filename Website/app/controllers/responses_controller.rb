class ResponsesController < ApplicationController
	def new
		@form = Form.find(params[:fid])
		@response = @form.responses.new
	end

	def create
		@form = Form.find(params[:fid])
		@response = @form.responses.create(response_params)
		redirect_to '/thanks'
	end

	private
		def response_params
      		params.require(:response).permit(:questions, :response)
    	end
end