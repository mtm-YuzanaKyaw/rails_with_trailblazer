class MoneyforwardCallbackController < ApplicationController
  attr_reader :token_endpoint,:client_id,:client_secret,:authorization_endpoint,:redirect_uri,:scope,:refresh_token
  def initialize
    @token_endpoint = ENV['TOKEN_ENDPOINT']
    @client_id = ENV['CLIENT_ID']
    @client_secret = ENV['CLIENT_SECRET']
    @authorization_endpoint = ENV['AUTHORIZATION_ENDPOINT']
    @redirect_uri = ENV['REDIRECT_URI']
    @scope = ENV['SCOPE']
    @refresh_token = ENV['REFRESH_TOKEN']
  end

  def callback
    
    auth_code = params[:code]

    if auth_code.present?

      return redirect_to home_index_path, notice: "Authcode include #{auth_code}"
    end
  end
end
