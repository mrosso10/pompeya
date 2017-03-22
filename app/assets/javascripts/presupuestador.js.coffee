
angular.module('presupuestador',[]);

angular.module('presupuestador').controller 'PresupuestadorCtrl',
  ($scope) ->
    $scope.add_child = (contenedor) ->
      # debugger
      contenedor.children = contenedor.children || []
      contenedor.children.push({name: 'hijito'})
    $scope.contenedores = [
      {
        name: "hola",
        children: [
          { name: "hijo 1"},
          { name: "hijo 2"}
        ]
      },
      {
        name: "hola 2",
        children: [
          { name: "hijo 3"}
        ]
      }
    ]
    $scope.editContenedor = (contenedor) ->
        contenedor.editing = true;

    $scope.doneEditing = (contenedor) ->
        contenedor.editing = false;


angular.module('presupuestador').directive 'myEnter', ->
  (scope, element, attrs) ->
    element.bind "keydown keypress", (event) ->
      if(event.which == 13)
        scope.$apply ->
          scope.$eval(attrs.myEnter);
        event.preventDefault();
