class CreateWorkoutsExercises < ActiveRecord::Migration[5.2]
  def change
    create_join_table :workouts, :exercises do |t|
      t.index :workout_id
      t.index :exercise_id
    end
  end
end
