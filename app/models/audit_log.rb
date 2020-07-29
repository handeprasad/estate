class AuditLog < ApplicationRecord

	belongs_to :user, polymorphic: true

	validates :note, presence: true, length: { maximum: 1000,
    too_long: "%{count} characters is the maximum allowed" }

    scope :notes_latest, -> { order("updated_at desc") }

end
