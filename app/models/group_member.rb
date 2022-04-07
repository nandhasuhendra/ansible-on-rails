class GroupMember < ApplicationRecord
  belongs_to :host
  belongs_to :group

  validates_uniqueness_of :host, :scope => :group_id
end
