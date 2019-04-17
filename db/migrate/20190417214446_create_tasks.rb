class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :name
      t.datetime :deadline
      t.integer :priority
      t.boolean :done, default: false
      t.references :project, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
