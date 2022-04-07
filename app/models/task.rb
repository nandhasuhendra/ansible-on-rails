class Task < ApplicationRecord
  validates :name,          presence: true, uniqueness: true, length: { in: 6..50 }
  validates :descriptions,  length: { maximum: 400 }
  validates :task_file,     uniqueness: true, allow_blank: true
end
