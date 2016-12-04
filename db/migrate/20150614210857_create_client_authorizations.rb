class CreateClientAuthorizations < ActiveRecord::Migration
  def change
    create_table :client_authorizations do |t|
      t.string :scopes, array: true, null: false, default: []
      t.references :app, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
