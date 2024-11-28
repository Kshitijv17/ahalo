
class SmsMessagesController < ApplicationController
    def create
      phone_number = params[:mobile_number]
      message = rand(10_00..99_99)
      if phone_number.present?
        # Fetch Twilio credentials from environment variables
        account_sid = ENV["ACCOUNT_SID"]
        auth_token = ENV["AUTH_TOKEN"]
        from = ENV["PHONE_NUMBER"]
        begin
          # Initialize Twilio client
          client = Twilio::REST::Client.new(account_sid, auth_token)
          # Send the SMS
          client.messages.create(
            from: from,
            to: phone_number,
            body: "Your OTP code is #{message}"
          )
          render json: { message: "OTP sent successfully." }, status: :ok
        rescue Twilio::REST::RestError => e
          Rails.logger.error "Twilio Error: #{e.message}"
          render json: { error: "Failed to send OTP. Please try again later." }, status: :unprocessable_entity
        end
      else
        render json: { error: "Phone number and OTP are required." }, status: :unprocessable_entity
      end
    end
  end