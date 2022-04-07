class Host < ApplicationRecord
  before_validation :change_whitespace

  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members

  VALID_IP_ADDRESS_REGEX = /\d[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/

  validates :name,        presence: true, uniqueness: true, length: { maximum: 100 }
  validates :ip_address,  presence: true, uniqueness: true, length: { in: 7..15 }, format: { with: VALID_IP_ADDRESS_REGEX }
  validates :port,        presence: true

  private
    def change_whitespace
      self.name = self.name.gsub(' ', '-')
    end
end
