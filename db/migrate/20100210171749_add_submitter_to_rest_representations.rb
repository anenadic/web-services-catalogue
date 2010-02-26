class AddSubmitterToRestRepresentations < ActiveRecord::Migration
  def self.up
    add_column :rest_representations, :submitter_id, :integer

    add_column :rest_representations, :submitter_type, :string, :default => "User"
    execute 'UPDATE rest_representations SET submitter_type = "User"'
  end

  def self.down
    remove_column :rest_representations, submitter_id
    remove_column :rest_representations, submitter_type
  end
end
