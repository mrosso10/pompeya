
angular.module('presupuestador', ['filtrosPresupuestador', 'counter']);

angular.module('presupuestador').controller 'PresupuestadorCtrl',
  ($scope, $timeout, rand) ->
    window.SCOPE = $scope
    $scope.current_contenedor = null

    $timeout( ->
      angular.element('.spinner-wrapper').fadeOut()
    ,1300)
    
    angular.element(document).ready ->
      pieData = {
        labels: ["Mano de Obra","Materiales","Subcontrato" ],
        datasets: [{
            data: [
              $scope.total_mano_de_obra().toFixed(2),
              $scope.total_materiales().toFixed(2),
              $scope.total_subcontratos().toFixed(2)
            ],
            backgroundColor: ["#a3e1d4","#dedede","#b5b8cf"]
        }]
      } ;

      pieOptions = {
        responsive: true,
        legend: {
          display: false
        }
      };

      ctx4 = document.getElementById("doughnutChart").getContext("2d");

      $scope.myChart = new Chart(ctx4, {type: 'doughnut', data: pieData, options:pieOptions}) ; 
    

    $scope.remove_line_item = (line_item) ->
      index = this.nodes[line_item.container_id].line_items.indexOf(line_item)
      this.nodes[line_item.container_id].line_items.splice(index, 1)

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
      $scope.selected_product = null
      $('#myModal').modal('show')
    
    $scope.contenedor_total = (contenedor, filter) ->
      total = 0
      for line_item in contenedor.line_items || []
        if filter == undefined || filter(line_item)
          total = total + line_item.product.price * line_item.quantity
      for child in contenedor.children || []
        total = total + $scope.contenedor_total(child, filter)
      total
    
    $scope.add_product = (product) ->
      contenedor = $scope.current_contenedor
      contenedor.line_items = contenedor.line_items || []
      contenedor.line_items.push({id: rand(), product_id: product.id, product: product, container_id: contenedor.id, quantity: 1 })
      $('#myModal').modal('hide')

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
        total += $scope.contenedor_total(n1, (line_item) -> line_item.product.is_work && !line_item.is_subcontrato)
      total
    $scope.total_materiales = ->
      total=0
      for n1 in $scope.contenedores || []
        total += $scope.contenedor_total(n1, (line_item) -> !line_item.product.is_work && !line_item.is_subcontrato)
      total

    $scope.total_subcontratos = ->
      total=0
      for n1 in $scope.contenedores || []
        total += $scope.contenedor_total(n1, (line_item) -> line_item.is_subcontrato)
      total
    $scope.container_index = (contenedor) ->
      if contenedor.parent_id?
        parent = this.nodes[contenedor.parent_id]
        $scope.container_index(parent) + "." + (parent.children.indexOf(contenedor) + 1)
      else
        this.contenedores.indexOf(contenedor) + 1

    $scope.all_products = [
      { id: 'NL10X5',       name: "Vigas",          price: 124.26,        is_work: false },
      { id: 'EF 1950',      name: "Cemento",        price: 324.12,        is_work: false },
      { id: 'A1815-250-CW', name: "Obrero",         price: 372.50,       is_work: true  },
      { id: 'A1815-250-RA', name: "Arquitecto",     price: 612.45,       is_work: true  },
      { id: 'KL-250',       name: "Instalación",    price: 232.21,    is_work: true  },
      { id: 'S-250',        name: "Ventanales ",    price: 602.52,    is_work: false },
    ]

    $scope.contenedores = [
      {
        id: 1124,
        name: "Ingeniería",
        line_items: [
          { id: rand(), container_id: 1124, product_id: 'NL10X5', quantity: 1, },
          { id: rand(), container_id: 1124, product_id: 'EF 1950', quantity: 2, }
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
            line_items: [
              { id: rand(), container_id: 3219, product_id: 'A1815-250-CW', quantity: 1, is_subcontrato: true },
              { id: rand(), container_id: 3219, product_id: 'A1815-250-RA', quantity: 2, }
            ]
          },
          {
            id: 6519,
            parent_id: 5232,
            name: "Torres",
            line_items: [
              { id: rand(), container_id: 6519, product_id: 'KL-250', quantity: 1, },
              { id: rand(), container_id: 6519, product_id: 'S-250', quantity: 2, }
            ]
          }
        ],
      },
    ]
    $scope.nodes = {}

    add_node = (node) ->
      $scope.nodes[node.id] = node
      for n1 in node.children || []
        add_node(n1)
      for n2 in node.line_items || []
        n2.product = $scope.all_products.find (product) -> product.id == n2.product_id
      
      
    for node in $scope.contenedores
      add_node(node)

    $scope.editContenedor = (contenedor) ->
      contenedor.editing = true;

    $scope.doneEditing = (contenedor) ->
      contenedor.editing = false;

    $scope.$watch "contenedores", (newValue,oldValue) ->

      $scope.myChart.data.datasets[0].data[0] =  $scope.total_mano_de_obra().toFixed(2);
      $scope.myChart.data.datasets[0].data[1] =  $scope.total_materiales().toFixed(2);
      $scope.myChart.data.datasets[0].data[2] =  $scope.total_subcontratos().toFixed(2);

      $scope.myChart.update();
    , true



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

angular.module('presupuestador').factory 'rand', ->
  (id) ->
    Math.round(Math.random() * 9999999)

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

