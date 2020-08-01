class CreateWorkouts < ActiveRecord::Migration[5.2]
  def change
    create_table :workouts do |t|
      t.string :name
      t.integer :duration
      t.string :state
      t.integer :creator_id

      t.timestamps
    end
  end
end
