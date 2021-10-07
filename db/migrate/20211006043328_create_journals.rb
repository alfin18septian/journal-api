class CreateJournals < ActiveRecord::Migration[6.1]
  def change
    create_table :journals do |t|
      t.string :title
      t.string :abstact
      t.string :full_text
      t.string :author
      t.integer :id_user
      t.datetime :verified_at

      t.timestamps
    end
  end
end
