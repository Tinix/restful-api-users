class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
  end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      @decoded = decode_token(token)
      @current_user = User.find(@decoded['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end
end
