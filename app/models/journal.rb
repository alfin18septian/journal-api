class Journal < ApplicationRecord
    belongs_to :upload
    validates :upload_id, presence: true
    validates :title, presence: true
    validates :abstact, presence: true
    validates :author, presence: true
end
