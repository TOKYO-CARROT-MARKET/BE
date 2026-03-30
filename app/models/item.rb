class Item < ApplicationRecord
  belongs_to :user

  PICKUP_TYPES = %w[pickup delivery both].freeze
  STATUSES = %w[selling reserved sold].freeze

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category, presence: true
  validates :region, presence: true
  validates :pickup_type, presence: true, inclusion: { in: PICKUP_TYPES }
  validates :status, presence: true, inclusion: { in: STATUSES }
end