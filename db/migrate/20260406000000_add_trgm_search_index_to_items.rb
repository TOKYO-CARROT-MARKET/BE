class AddTrgmSearchIndexToItems < ActiveRecord::Migration[8.0]
  def up
    enable_extension "pg_trgm"

    execute <<~SQL
      CREATE INDEX items_search_trgm_idx ON items
      USING GIN ((title || ' ' || description) gin_trgm_ops);
    SQL
  end

  def down
    execute "DROP INDEX IF EXISTS items_search_trgm_idx;"
  end
end
