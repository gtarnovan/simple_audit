class SimpleAuditMigration < ActiveRecord::Migration
  def self.up
    create_table :audits do |t|
      t.belongs_to :auditable,  :polymorphic => true
      t.belongs_to :user,       :polymorphic => true

      t.string :username
      t.string :action
      t.text   :change_log
      t.timestamps

    end

    add_index :audits, [:auditable_id, :auditable_type], :name => 'auditable_index'
    add_index :audits, [:user_id, :user_type], :name => 'user_index'
    add_index :audits, :created_at
  end

  def self.down
    drop_table :audits
  end
end