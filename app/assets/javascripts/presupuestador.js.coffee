
angular.module('presupuestador', ['filtrosPresupuestador', 'counter']);

angular.module('presupuestador').controller 'PresupuestadorCtrl',
  ($scope) ->
    window.SCOPE = $scope
    $scope.current_contenedor = null
    
    $scope.remove_product = (product) ->
      index = this.nodes[product.container_id].products.indexOf(product)
      this.nodes[product.container_id].products.splice(index, 1)

    $scope.remove = (contenedor) ->
      if contenedor.parent_id?
        collection = this.nodes[contenedor.parent_id].children
      else
        collection = this.contenedores
      index = collection.indexOf(contenedor)
      collection.splice(index,1)

    $scope.add_child = (contenedor) ->
      new_contenedor= {id: Math.round(Math.random() * 9999999), name: '', editing: true} # Como generamos ID ?
      if contenedor
        contenedor.children = contenedor.children || []
        new_contenedor['parent_id'] = contenedor.id
        contenedor.children.push new_contenedor
      else
        $scope.contenedores.push new_contenedor
      add_node(new_contenedor)
    
    $scope.open_modal = (contenedor) ->
      $scope.current_contenedor = contenedor
      $('#myModal').modal('show')
    
    $scope.open_modal_work = (contenedor) ->
      $scope.current_contenedor = contenedor
      $('#myModalWork').modal('show')
    
    $scope.contenedor_total = (contenedor, filter) ->
      total = 0
      for product in contenedor.products || []
        if filter == undefined || filter(product)
          total = total + product.price * product.quantity
      for child in contenedor.children || []
        total = total + $scope.contenedor_total(child, filter)
      total
    
    $scope.add_product = (product) ->
      contenedor = $scope.current_contenedor
      contenedor.products = contenedor.products || []
      contenedor.products.push({id: product.id, name: product.name, price: product.price, is_work: product.is_work, container_id: contenedor.id, quantity: 1})
      $('#myModal').modal('hide')
      $('#myModalWork').modal('hide')

    $scope.collapse = (contenedor) ->
      contenedor.collapse = !contenedor.collapse

    $scope.total_pesupuesto = ->
      total=0
      for n1 in $scope.contenedores || []
        total += $scope.contenedor_total(n1)
      total
    $scope.total_mano_de_obra = ->
      total=0
      for n1 in $scope.contenedores || []
        total += $scope.contenedor_total(n1, (product) -> product.is_work && !product.is_subcontrato)
      total
    $scope.total_materiales = ->
      total=0
      for n1 in $scope.contenedores || []
        total += $scope.contenedor_total(n1, (product) -> !product.is_work && !product.is_subcontrato)
      total

    $scope.total_subcontratos = ->
      total=0
      for n1 in $scope.contenedores || []
        total += $scope.contenedor_total(n1, (product) -> product.is_subcontrato)
      total
    $scope.container_index = (contenedor) ->
      if contenedor.parent_id?
        parent = this.nodes[contenedor.parent_id]
        $scope.container_index(parent) + "." + (parent.children.indexOf(contenedor) + 1)
      else
        this.contenedores.indexOf(contenedor) + 1

    $scope.all_products = [
      {
          id:1,
          name: "Vigas",
          price: 20,
          is_work: false,
      },
      {
          id:2,
          name: "Cemento",
          price: 30,
          is_work: false,
      },
      {
        id:3,
        name: "Obrero",
        price: 100,
        is_work: true
      },
      {
        id:4,
        name: "Arquitecto",
        price: 150,
        is_work: true
      }
    ]

    $scope.contenedores = [
      {
        id: 1124,
        name: "Ingeniería",
        products: [
          { id: 'NL10X5', container_id: 1124, name: "Relevamiento", price: 232.21, quantity: 1, is_work:true},
          { id: 'EF 1950', container_id: 1124, name: "Análisis ", price: 602.52, quantity: 2, is_work:true}
        ]
      },
      {
        id: 5232,
        name: "Instalación",
        children: [
          {
            id: 3219,
            parent_id: 5232,
            name: "Pisos",
            products: [
              { id: 'A1815-250-CW', container_id: 3219, name: "Instalación", price: 232.21, quantity: 1, is_work:true, is_subcontrato: true},
              { id: 'A1815-250-RA', container_id: 3219, name: "Ventanales ", price: 602.52, quantity: 2, is_work:false}
            ]
          },
          {
            id: 6519,
            parent_id: 5232,
            name: "Torres",
            products: [
              { id: 'KL-250', container_id: 6519, name: "Instalación", price: 232.21, quantity: 1, is_work:true},
              { id: 'S-250', container_id: 6519, name: "Ventanales ", price: 602.52, quantity: 2, is_work:false}
            ]
          }
        ],
      },
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



