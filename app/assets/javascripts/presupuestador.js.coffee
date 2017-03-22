
angular.module('presupuestador',[]);

angular.module('presupuestador').controller 'PresupuestadorCtrl',
  ($scope) ->
    $scope.remove = (contenedor) ->
      debugger
      # contenedor.children = contenedor.children || []
      # contenedor.children.push({name: '', editing: true})
    $scope.add_child = (contenedor) ->
      contenedor.children = contenedor.children || []
      contenedor.children.push({name: '', editing: true})
    $scope.add_product = (contenedor) ->
      contenedor.products = contenedor.products || []
      contenedor.products.push({code: '', name: ''})
    $scope.collapse = (contenedor) ->
      contenedor.collapse = !contenedor.collapse

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

angular.module('presupuestador').directive 'eventFocus', ['focus', (focus) ->
  (scope, elem, attr) ->
    focus(elem)
]

angular.module('presupuestador').factory 'focus', ($timeout) ->
  (id) ->
    $timeout ->
      if element = angular.element(id)
        element.focus()