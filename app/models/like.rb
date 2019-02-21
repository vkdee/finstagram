class Like < ActiveRecord::Base
    
    belongs_to :user
    belongs_to :vee_post

  # New validation code
  validates_presence_of  :user, :vee_post
    
end