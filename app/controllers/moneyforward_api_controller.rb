require 'httparty'
require 'dotenv/load'
require 'uri'

class MoneyforwardApiController < ApplicationController
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

  def authorize
    authorization_url = "#{@authorization_endpoint}?" +
    "response_type=code&" +
    "client_id=#{@client_id}&" +
    "scope=#{@scope}&" +
    "redirect_uri=#{@redirect_uri}"

    redirect_to authorization_url, allow_other_host: true
  end
end