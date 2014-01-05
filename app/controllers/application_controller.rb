require 'oauth2'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def index
  end
  
  def ping_me
    head :ok
  end
  
  def next_event
    next_meeting = Event.current
    if next_meeting
      render :json => {"date" => next_meeting}.to_json,
             :status => :ok
    else
      head :ok
    end
  end

  def attendings
    render :json => Attending.list.to_json,
           :status => :ok
  end

  def github_auth
    url = client.auth_code.authorize_url(:redirect_uri => redirect_uri, :scope => '')
    puts "Redirecting to URL: #{url.inspect}"
    redirect_to url
  end

  def github_callback
    access_token = client.auth_code.get_token params[:code], redirect_uri: redirect_uri
    user = JSON.parse access_token.get("https://api.github.com/user").body
    username = user["login"]

    if Attending.exists?(username)
      Attending.cancel username
      response.delete_cookie(:github_signedin.to_s, :path => "/")
    else
      Attending.add user
      response.set_cookie(:github_signedin.to_s, 
                    :value => username, 
                    :path => "/")
    end

    redirect_to :root
  end
  
  private
    def client
      OAuth2::Client.new ENV['GITHUB_CLIENT_ID'],
                         ENV['GITHUB_CLIENT_SECRET'],
                         site: 'https://github.com',
                         authorize_url: 'https://github.com/login/oauth/authorize',
                         token_url: 'https://github.com/login/oauth/access_token'
    end

    def redirect_uri(path = '/auth/github/callback', query = nil)
      uri = URI.parse(request.url)
      uri.path  = path
      uri.query = query
      uri.to_s
    end
  
end
