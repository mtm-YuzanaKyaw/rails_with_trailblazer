require 'httparty'
require 'dotenv/load'
require 'uri'

class MoneyforwardCallbackController < ApplicationController
  attr_reader :token_endpoint,:client_id,:client_secret,:redirect_uri,:scope,:refresh_token,:billings_endpoint
  def initialize
    @token_endpoint = ENV['TOKEN_ENDPOINT']
    @client_id = ENV['CLIENT_ID']
    @client_secret = ENV['CLIENT_SECRET']
    @redirect_uri = ENV['REDIRECT_URI']
    @scope = ENV['SCOPE']
    @refresh_token = ENV['REFRESH_TOKEN']
  end

  def callback
    auth_code = params[:code]

    if auth_code.present?
      response = HTTParty.post(token_endpoint,{
        basic_auth: {
          username: client_id,
          password: client_secret
        },
        body: {
          grant_type: 'authorization_code',
          code: auth_code,
          redirect_uri: redirect_uri
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      })

      if response.success?
        current_user.moneyforward_credentials.destroy_all
        current_user.moneyforward_credentials.create!(
          access_token: response["access_token"],
          refresh_token: response["refresh_token"],
          expired_at: response["expires_in"].to_i
        )

        session[:moneyforward_access_token] = response["access_token"]
        session[:moneyforward_expires_at] = Time.current + response["expires_in"].to_i.seconds
        
        return redirect_to moneyforward_billings_path
      else
        return redirect_to home_index_path, notice: "Access token cannot be fetched #{response}"
      end 
    end
  end

  def billings 
  end
end
