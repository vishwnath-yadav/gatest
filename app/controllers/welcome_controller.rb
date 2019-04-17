class WelcomeController < ApplicationController

  def index
  end

  def auth_link
    #this is adding comment only
    #added one more commit
    #hcnage in welcome contoller

    

    
    
    client = Signet::OAuth2::Client.new({
      client_id: '1047963797640-oohtkqo7iebvj61mhqdl9n72t0rnpcae.apps.googleusercontent.com',
      client_secret: 'Yc6idcadksN_-2KHLLiEPNUO',
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::AnalyticsV3::AUTH_ANALYTICS_READONLY,
      redirect_uri: url_for(:action => :oauth2callback)
    })
    # byebug
    redirect_to client.authorization_uri.to_s
  end

  def oauth2callback
    #this is auth mehtod only
    client = Signet::OAuth2::Client.new({
      client_id: '1047963797640-oohtkqo7iebvj61mhqdl9n72t0rnpcae.apps.googleusercontent.com',
      client_secret: 'Yc6idcadksN_-2KHLLiEPNUO',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: url_for(:action => :oauth2callback),
      code: params[:code]

      #add one more space
    })

    @response = client.fetch_access_token!
    # byebug
    session[:access_token] = @response['access_token']

    redirect_to url_for(:action => :analytics)
  end

  def analytics
    client = Signet::OAuth2::Client.new(access_token: session[:access_token])

    service = Google::Apis::AnalyticsV3::AnalyticsService.new
    # byebug
    service.authorization = client

    @account_summaries = service.list_account_summaries
  end

end
