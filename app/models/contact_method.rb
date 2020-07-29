class ContactMethod < ApplicationRecord
  has_many :financial_institution_contact_methods
  has_many :inancial_institutions, through: :financial_institution_contact_methods

  scope :emailable, -> {
    where(channel: 'email')
  }
  scope :postable, -> {
    where(channel: 'post')
  }

  def via
    name.gsub(' ', '_').to_sym || :smtp
  end

  def is_email?
    channel=='email'
  end

  def is_post?
    channel=='post'
  end

  def self.generate_data
    ContactMethod.find_or_create_by(name: 'aws_ses', channel: 'email')
    ContactMethod.find_or_create_by(name: 'microsoft_graph', channel: 'email')
    ContactMethod.find_or_create_by(name: 'docmail', channel: 'post')
    ContactMethod.find_or_create_by(name: 'sendgrid', channel: 'email')
  end
end
