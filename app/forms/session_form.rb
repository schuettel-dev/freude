class SessionForm
  include ActiveModel::Model

  validates :token, presence: true
  validate :valid_token

  def initialize(params: {})
    @params = params
  end

  def model_name
    ActiveModel::Name.new(self, nil, "Session")
  end

  def token
    @params.dig(:session, :token)
  end

  def user
    @user ||= User.find_by(session_params)
  end

  private

  def valid_token
    return if errors.any?
    return if user.present?

    errors.add(:token, :does_not_exist)
  end

  def session_params
    @params.require(:session).permit(:token)
  end
end
