class JournalCategory < ApplicationRecord
  belongs_to :journal
  belongs_to :category
end
