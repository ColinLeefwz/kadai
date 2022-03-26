# frozen_string_literal: true

class Image < ApplicationRecord
  has_one_attached :avatar

  validates :title, presence: true, length: { maximum: 30 }
  validates :avatar, presence: true
end
