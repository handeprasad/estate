class Address < ApplicationRecord
  PARAMS = [
    :id,
    :flat,
    :house_name,
    :house_number,
    :street,
    :district,
    :post_town,
    :county,
    :postcode
  ]

  belongs_to :owner, polymorphic: true, touch: true
  belongs_to :source, polymorphic: true

  default_scope -> { order(:created_at) }

  validate :first_line_of_address_is_valid
  validates :postcode, presence: true

  def to_s
    [
      flat,
      house_name,
      [house_number, street].select(&:present?).join(' '),
      district,
      post_town,
      county,
      postcode
    ].select(&:present?).join("\n")
  end

  def to_one_line
    to_s.gsub("\n", ", ")
  end

  private

  def first_line_of_address_is_valid
    if [house_name, house_number, flat].all?(&:blank?)
      errors.add(:first_line, "must include at least one of House Name, House Number or Flat")
    end
  end
end
