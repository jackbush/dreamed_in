class Dream < ActiveRecord::Base

  validates :title, presence: true
  validates :description, presence: true

  mount_uploader :dream_image, DreamImageUploader

end
