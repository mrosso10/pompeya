
angular.module('presupuestador',[]);

angular.module('presupuestador').controller 'PresupuestadorCtrl',
  ($scope) ->
    window.SCOPE = $scope
    $scope.current_contenedor = null
    
    $scope.remove_product = (product) ->
      index = this.nodes[product.container_id].products.indexOf(product)
      this.nodes[product.container_id].products.splice(index, 1)
    $scope.remove = (contenedor) ->
      if contenedor.parent_id?
        index = this.nodes[contenedor.parent_id].children.indexOf(contenedor)
        this.nodes[contenedor.parent_id].children.splice(index, 1)
      else
        index = this.contenedores.indexOf(contenedor)
        this.contenedores.splice(index,1)

      # contenedor.children = contenedor.children || []
      # contenedor.children.push({name: '', editing: true})
    $scope.add_child = (contenedor) ->
      contenedor.children = contenedor.children || []
      contenedor.children.push({name: '', editing: true, parent_id: contenedor.id})
    $scope.open_modal = (contenedor) ->
      $scope.current_contenedor = contenedor
      $('#myModal').modal('show')
    $scope.contenedor_total = (contenedor) ->
      total = 0
      for product in contenedor.products || []
        total = total + product.price * product.quantity
      for child in contenedor.children || []
        total = total + $scope.contenedor_total(child)
      Math.round(total*100)/100 # Sino bardean los decimales

    $scope.add_product = (product) ->
      contenedor = $scope.current_contenedor
      contenedor.products = contenedor.products || []
      contenedor.products.push({id: product.id, name: product.name, price: product.price, container_id: contenedor.id, quantity: 1})
      $('#myModal').modal('hide')
    $scope.collapse = (contenedor) ->
      contenedor.collapse = !contenedor.collapse

    $scope.add_contenedor =  ->
      new_contenedor= {id:33,name:"Nuevo Contenedor"} # Como generamos ID ?
      $scope.contenedores.push(new_contenedor)
      add_node(new_contenedor)

    $scope.total_pesupuesto = ->
      total=1
      for n1 in $scope.contenedores || []
        total += $scope.contenedor_total(n1)
      total

    $scope.all_products = [
      {
          id:1,
          name: "Producto1",
          price: 20,
      },
      {
          id:2,
          name: "Producto2",
          price: 30,
      }
    ]

    $scope.contenedores = [
      {
        id: 1124,
        name: "hola",
        children: [
          {
            id: 6513,
            parent_id: 1124,
            name: "hijo 1"
          },
          {
            id: 3249,
            parent_id: 1124,
            name: "hijo 2",
            products: [
              { id: 1241, container_id: 3249, name: "producto 1", price: 232.21, quantity: 1},
              { id: 2323, container_id: 3249, name: "producto 2", price: 602.52, quantity: 2}
            ]
          }
        ],
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
