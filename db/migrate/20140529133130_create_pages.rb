class CreatePages < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE pages (
        id serial PRIMARY KEY,
        tree ltree UNIQUE
      );

      CREATE INDEX tree_gist_pages_idx ON pages USING GIST(tree);
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE pages;
    SQL
  end
end
