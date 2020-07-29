# frozen_string_literal: true

class CreateRepositoryBranches < (
    Rails.version < '5.2' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  )
  def change
    create_table :repository_branches do |t|
      t.references :repository, index: true, foreign_key: true
      t.string :name
      t.string :revision

      t.timestamps null: false
    end
  end
end
