class Identity < ActiveRecord::Base
  validates_uniqueness_of :uid, :scope => :provider, :case_sensitive => false
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
end
