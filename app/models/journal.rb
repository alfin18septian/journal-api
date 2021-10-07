class Journal < ApplicationRecord
    validates :title, presence: true
    validates :abstact, presence: true
    validates :full_text, presence: true
    validates :author, presence: true
end
