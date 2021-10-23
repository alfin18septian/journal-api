class AddUploadToJournals < ActiveRecord::Migration[6.1]
  def change
    add_reference :journals, :upload
  end
end
