class MoneyforwardBillingsController < ApplicationController
  def index
    billings_endpoint = ENV['INVOICE_ENDPOINT']
    access_token = session[:moneyforward_access_token]
    expires_at = session[:moneyforward_expires_at]

    billings_response = HTTParty.get(billings_endpoint,{
      headers: {
        Accept: "application/json",
        Authorization: "Bearer #{access_token}"
        }
      })
    if billings_response.success?
      @invoices = JSON.parse(billings_response.body)["data"]
    else
      return redirect_to home_index_path, notice: "Invoice data connot be fetched #{billings_response.to_json}"
    end
  end

  def show
    billings_endpoint = "#{ENV['INVOICE_ENDPOINT']}/#{params[:id]}"
    client_id = ENV["CLIENT_ID"]
    client_secret = ENV["CLIENT_SECRET"]
    redirect_uri = ENV["REDIRECT_URI"]
    access_token = session[:moneyforward_access_token]
    expires_at = session[:moneyforward_expires_at]

    if access_token.blank? || Time.current > expires_at
      credentials = moneyforward_credentials.find_by(user_id: current_user.id)
      refresh_token = credentials.refresh_token
      response = HTTParty.post(token_endpoint,{
        basic_auth: {
          username: client_id,
          password: client_secret
        },
        body: {
          grant_type: 'refresh_token',
          refresh_token: refresh_token,
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

    billings_response = HTTParty.get(billings_endpoint,{
      headers: {
        Accept: "application/json",
        Authorization: "Bearer #{access_token}"
      }
    })

    if billings_response.success?
      @invoice = JSON.parse(billings_response.body)
    else
      return redirect_to home_index_path, notice: "Invoice data connot be fetched #{billings_response.to_json}"
    end
  end
end
