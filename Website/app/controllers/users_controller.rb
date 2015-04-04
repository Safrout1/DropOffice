require 'dropbox_sdk'
require 'securerandom'

APP_KEY = "z7ktftzujsts6za" 
APP_SECRET = "f57rj5da65qg3ja"


class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @client = get_dropbox_client
    unless @client
        redirect_to(:action => 'auth_start') and return
    end
    @account_info = @client.account_info
    @metadata = @client.metadata('/')
  end

  def search
    @client = get_dropbox_client
    unless @client
        redirect_to(:action => 'auth_start') and return
    end
    begin
        @search = @client.search('/', params[:query])
        respond_to do |format|
            format.js {}
        end
    rescue DropboxAuthError => e
        session.delete(:access_token)  # An auth error means the access token is probably bad
        logger.info "Dropbox auth error: #{e}"
        #render :text => "Dropbox auth error"
        flash[:danger] = "Dropbox auth error"
    rescue DropboxError => e
        logger.info "Dropbox API error: #{e}"
        #render :text => "Dropbox API error"
        flash[:danger] = "Dropbox API error"
    end
  end

  def dropbox_change
    @client = get_dropbox_client
    unless @client
        redirect_to(:action => 'auth_start') and return
    end
    @metadata = @client.metadata(params[:path])
    respond_to do |format|
            format.js {}
    end
  end
 
  def dropbox_download
    @client = get_dropbox_client
    unless @client
        redirect_to(:action => 'auth_start') and return
    end
    redirect_to @client.shares(params[:path])["url"]
  end

  def upload
    @client = get_dropbox_client
    unless @client
        redirect_to(:action => 'auth_start') and return
    end
    begin
        x = nil
        if params[:path]
            x = "#{params[:path]}/"
        end
        # Upload the POST'd file to Dropbox, keeping the same name
        resp = @client.put_file("#{x}#{params[:file].original_filename}", params[:file].read)
        #render :text => "Upload successful.  File now at #{resp['path']}"
        flash[:success] = "Upload successful.  File now at #{resp['path']}"
    rescue DropboxAuthError => e
        session.delete(:access_token)  # An auth error means the access token is probably bad
        logger.info "Dropbox auth error: #{e}"
        #render :text => "Dropbox auth error"
        flash[:danger] = "Dropbox auth error"
    rescue DropboxError => e
        logger.info "Dropbox API error: #{e}"
        #render :text => "Dropbox API error"
        flash[:danger] = "Dropbox API error"
    end
    @user = User.find_by(id: session['user_id'])
    redirect_to @user
  end

  def new
    @user = User.new
    @@class_user = @user
  end

  def create
    @user = User.new(user_params)
    @@class_user = @user
    if @user.save
      log_in @user
      flash[:success] = "Welcome to DropOffice!"
      redirect_to @user
    else
      render 'new'
    end
  end


  def get_dropbox_client
        if session[:access_token]
            begin
                access_token = session[:access_token]
                DropboxClient.new(access_token)
            rescue
                # Maybe something's wrong with the access token?
                session.delete(:access_token)
                raise
            end
        end
    end

    def get_web_auth
        redirect_uri = url_for(:action => 'auth_finish')
        DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, redirect_uri, session, :dropbox_auth_csrf_token)
    end

    def auth_start
        authorize_url = get_web_auth().start()

        # Send the user to the Dropbox website so they can authorize our app.  After the user
        # authorizes our app, Dropbox will redirect them here with a 'code' parameter.
        redirect_to authorize_url
    end

    def auth_finish
        begin
            access_token, user_id, url_state = get_web_auth.finish(params)
            session[:access_token] = access_token
            @user = User.find_by(id: session['user_id'])
            redirect_to @user
        rescue DropboxOAuth2Flow::BadRequestError => e
            render :text => "Error in OAuth 2 flow: Bad request: #{e}"
        rescue DropboxOAuth2Flow::BadStateError => e
            logger.info("Error in OAuth 2 flow: No CSRF token in session: #{e}")
            redirect_to(:action => 'auth_start')
        rescue DropboxOAuth2Flow::CsrfError => e
            logger.info("Error in OAuth 2 flow: CSRF mismatch: #{e}")
            render :text => "CSRF error"
        rescue DropboxOAuth2Flow::NotApprovedError => e
            render :text => "Not approved?  Why not, bro?"
        rescue DropboxOAuth2Flow::ProviderError => e
            logger.info "Error in OAuth 2 flow: Error redirect from Dropbox: #{e}"
            render :text => "Strange error."
        rescue DropboxError => e
            logger.info "Error getting OAuth 2 access token: #{e}"
            render :text => "Error communicating with Dropbox servers."
        end
    end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end