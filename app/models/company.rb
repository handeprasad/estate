class Company < ApplicationRecord
  has_many :cases
  has_many :users

  validates :name, presence: true

  validates_format_of :telephone,
      :with => /\A[0-9]\d*\Z/,
      :message => "number must be numeric",
      :allow_blank => true

  validate :check_for_date_registered, if: -> { date_registered.present? }


  def check_for_date_registered
    errors.add(:date_registered, 'Warning - Date Registered cannot be in the Future.') if Date.today < self.date_registered
  end
end
