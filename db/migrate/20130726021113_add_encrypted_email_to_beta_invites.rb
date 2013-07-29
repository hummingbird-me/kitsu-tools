class AddEncryptedEmailToBetaInvites < ActiveRecord::Migration
  def change
    add_column :beta_invites, :encrypted_email, :string
    BetaInvite.find_each do |b|
      b.update_column :encrypted_email, SecureRandom.hex
    end
  end
end
