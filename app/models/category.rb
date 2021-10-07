class Category < ApplicationRecord
    validates :category, presence: true, uniqueness: true
end
