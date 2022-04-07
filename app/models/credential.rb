class Credential < ApplicationRecord
  has_many :groups, dependent: :nullify

  KEY_TYPE = [ 'RSA', 'DSA' ]

  validates :name,      presence: true, uniqueness: true, length: { in: 6..25 }
  validates :key_type,  presence: true, length: { is: 3 }, inclusion: { in: KEY_TYPE }
  validates :file_name, uniqueness: true
end
