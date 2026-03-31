class User < ApplicationRecord
  has_many :items, dependent: :destroy

  PROVIDER_GOOGLE = "google".freeze

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :provider_uid, presence: true, uniqueness: { scope: :provider }
  validates :nickname, presence: true, uniqueness: true

  def self.find_or_create_from_google!(auth:)
    provider = PROVIDER_GOOGLE
    provider_uid = auth[:uid]
    email = auth.dig(:info, :email)&.downcase
    email_verified = auth.dig(:info, :email_verified) || false

    user = find_by(provider: provider, provider_uid: provider_uid)

    return user.tap { |u| u.update!(last_sign_in_at: Time.current) } if user

    nickname = generate_unique_nickname(base: auth.dig(:info, :name) || email&.split("@")&.first || "user")

    create!(
      provider: provider,
      provider_uid: provider_uid,
      email: email,
      email_verified: email_verified,
      nickname: nickname,
      profile_image_url: nil,
      last_sign_in_at: Time.current
    )
  end

  def self.generate_unique_nickname(base:)
    normalized = base.to_s.downcase.gsub(/[^a-z0-9가-힣_]/, "_").gsub(/_+/, "_").gsub(/\A_+|_+\z/, "")
    normalized = "user" if normalized.blank?

    candidate = normalized
    suffix = 1

    while exists?(nickname: candidate)
      suffix += 1
      candidate = "#{normalized}_#{suffix}"
    end

    candidate
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
