class CreatePerformances < ActiveRecord::Migration[5.2]
  def change
    create_table :performances do |t|
      t.integer :trainee_id
      t.integer :workout_id
      t.text :results
      t.timestamp :performed_at
    end
  end
end
