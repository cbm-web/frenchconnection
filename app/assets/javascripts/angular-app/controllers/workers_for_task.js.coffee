angular.module('Orwapp').controller 'WorkersForTaskController', ($scope, User, $http) ->

  $scope.workers = User.query()
  console.log "Found workers: #{$scope.workers}"

  # TODO Populate this with @task.users to begin with.
  $scope.selected_workers = []

  $scope.select = (worker) ->
    url          = '/tasks/select_workers'
    worker_id    = worker.id
    task_id      = $('[data-task-id]').first().data('task-id')

    # Let Rails know about the selection
    $http(
      method: 'POST'
      url: url
      params: {task_id: task_id, worker_id: worker_id }
    ).success((data, status) ->
      #return
    ).error (data, status) ->
      alert('failed')
      return
    
    # Put it in selected
    $scope.selected_workers.push worker
 
