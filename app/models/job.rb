class Job < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :task

  validates :name,          presence: true, uniqueness: true, length: { minimum: 6 }
  validates :descriptions,  length: { maximum: 255 }
end
