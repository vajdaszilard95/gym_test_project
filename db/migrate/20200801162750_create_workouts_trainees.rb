class CreateWorkoutsTrainees < ActiveRecord::Migration[5.2]
  def change
    create_table :workouts_trainees, id: false do |t|
      t.integer :workout_id
      t.integer :trainee_id
    end
    add_index :workouts_trainees, :workout_id
    add_index :workouts_trainees, :trainee_id
  end
end
