class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments, id: :uuid do |t|
      t.string :text
      t.references :task, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
