
angular.module('presupuestador',[]);

angular.module('presupuestador').controller 'PresupuestadorCtrl',
  ($scope) ->
    window.SCOPE = $scope
    $scope.remove = (contenedor) ->
      index = this.nodes[contenedor.parent_id].children.indexOf(contenedor)
      this.nodes[contenedor.parent_id].children.splice(index, 1)
      # contenedor.children = contenedor.children || []
      # contenedor.children.push({name: '', editing: true})
    $scope.add_child = (contenedor) ->
      contenedor.children = contenedor.children || []
      contenedor.children.push({name: '', editing: true, parent_id: contenedor.id})
    $scope.add_product = (contenedor) ->
      contenedor.products = contenedor.products || []
      contenedor.products.push({code: '', name: '', container_id: contenedor.id})
    $scope.collapse = (contenedor) ->
      contenedor.collapse = !contenedor.collapse

    $scope.contenedores = [
      {
        id: 1124,
        name: "hola",
        children: [
          { id: 6513, parent_id: 1124, name: "hijo 1"},
          { id: 3249, parent_id: 1124, name: "hijo 2"}
        ]
      },
      {
        id: 5232,
        name: "hola 2",
        children: [
          { id: 6543, parent_id: 5232, name: "hijo 3"}
        ]
      }
    ]
    $scope.nodes = {}

    add_node = (node) ->
      $scope.nodes[node.id] = node
      for n2 in node.children || []
        add_node(n2)
      
      
    for node in $scope.contenedores
      add_node(node)

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

angular.module('presupuestador').directive 'focusOnShow', ($timeout) ->
  {
    restrict: 'A'
    link: ($scope, $element, $attr) ->
      if $attr.ngShow
        $scope.$watch $attr.ngShow, (newValue) ->
          if newValue
            $timeout (->
              $element[0].focus()
            ), 0
      if $attr.ngHide
        $scope.$watch $attr.ngHide, (newValue) ->
          if !newValue
            $timeout (->
              $element[0].focus()
            ), 0

  }
