$(document).ready ->
  $('select#trainee_expertise_area').change (event) ->
    options = (grouped_trainers[event.target.value] || []).map (trainer) ->
      $('<option value="' + trainer.id + '">' + trainer.first_name + ' ' + trainer.last_name + '</option>')
    options.unshift($('<option value=""></option>'))
    $('select#trainee_trainer_id').html(options)
