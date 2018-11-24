class UserProfile < ApplicationRecord
  belongs_to :user, optional: true
  has_many :items, dependent: :destroy
  has_many :borrow_requests, dependent: :destroy
  has_one_attached :avatar
  # Validation for avatar
  # Validate content type
  # validates_attachment_content_type :avatar, content_type: /\Aimage/
  # # Validate filename
  # validates_attachment_file_name :avatar, matches: [/png\Z/, /jpe?g\Z/]

  # validate postal code must exist
  validates :username, presence: {message: "must exist"}
  validate :address_exists?
  geocoded_by :address
  after_validation :geocode

  after_save :update_profile_id_in_users

  def update_profile_id_in_users
    @user = User.find(self.user_id)
    if @user.present?
      @user.update_attribute(:user_profile_id, self.id)
    end
  end

  def address_exists?
    if self.address.nil?
      return
    end

    if self.address["street_address"] == ""
      self.errors.add(:street_address, "can not be empty")
    end

    if self.address["city"] == ""
      self.errors.add(:city, "can not be empty")
    end

    if (self.address["postal_code"] =~ /\A[abceghjklmnprstvxyABCEGHJKLMNPRSTVXY]{1}\d{1}[a-zA-Z]{1}[ -]?\d{1}[a-zA-Z]{1}\d{1}\z/).nil?
      self.errors.add(:postal_code, "invalid!")
    end
  end
end
