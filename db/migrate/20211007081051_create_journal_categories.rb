class CreateJournalCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :journal_categories do |t|
      t.references :journal, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
