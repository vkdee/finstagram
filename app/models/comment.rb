class Comment < ActiveRecord::Base

    belongs_to :user
    belongs_to :vee_post

  # New validation code
  validates_presence_of :text, :user, :vee_post
    
end
