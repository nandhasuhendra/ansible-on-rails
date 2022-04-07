class Group < ApplicationRecord
  has_many    :group_members, dependent: :destroy
  has_many    :hosts, through: :group_members
  has_many    :job, dependent: :nullify

  belongs_to :credential, optional: true

  validates :name,          uniqueness: true, presence: true, length: { in: 6..25 }
  validates :descriptions,  length: { maximum: 255 }
end
