class CreateReports < ActiveRecord::Migration[4.2]

  create_table :reports do |t|
    t.references :reportable, polymorphic: true
    t.references :user
    t.string :reason
    t.text :body

    t.timestamps
  end

end
