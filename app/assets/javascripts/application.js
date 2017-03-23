// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery/jquery-3.1.1.min.js
//= require bootstrap-sprockets
//= require metisMenu/jquery.metisMenu.js
//= require pace/pace.min.js
//= require slimscroll/jquery.slimscroll.min.js
//= require angular
//= require_tree .

receta = angular.module('receta',[]);

receta.controller('myCtrl' , function($scope) {
    // Todos los productos, teoricamente vendrían de la base
    $scope.all_products = [{
        id:1,
        name: "Producto1",
        precio: 20,
    },
    {
        id:2,
        name: "Producto2",
        precio: 40,
    },
    {
        id:3,
        name: "Producto3",
        precio: 5,
    }];

    $scope.contenedores = [{
        name: "contenedor #1",
        editing: false,
        displaying: false,
        productos: [
            $scope.all_products[0] ,$scope.all_products[1]
        ]
    }, {
        name: "contenedor #2",
        editing: false,
        displaying: false,
        productos: [
            $scope.all_products[2] ,$scope.all_products[1]
        ]
    }, {
        name: "contenedor #3",
        editing: false,
        displaying: false,
        productos: [
            $scope.all_products[1] ,$scope.all_products[0]
        ]
    }];


    $scope.addContenedor = function () {
        debugger;
        console.log("asd");
        var i = {name: "Nuevo Contenedor", editing: false};
        $scope.contenedores.push(i);
        console.log(contenedores);
    };

    $scope.sumarPrecios = function(contenedor) {
        var sum = 0;
        for (var i = 0; i < contenedor.productos.length; i++) {
            sum += contenedor.productos[i].precio;
        }
        contenedor.sumatoria = sum;
    };

    $scope.editContenedor = function (contenedor) {
        contenedor.editing = true;
    };

    $scope.doneEditing = function (contenedor) {
        contenedor.editing = false;
        //TODO Pegarle al backend y guardar
    };

    // Calculo el precio inicial de los contenedores sumando las sumas de los productos
    angular.element(document).ready(function () {
        for (var i = 0; i < $scope.contenedores.length; i++) {
            $scope.sumarPrecios($scope.contenedores[i]);
        }
    });

});

// Detecto el Enter para los campos donde se edita texto a mano
receta.directive('myEnter', function () {
    return function (scope, element, attrs) {
        element.bind("keydown keypress", function (event) {
            if(event.which === 13) {
                scope.$apply(function (){
                    scope.$eval(attrs.myEnter);
                });
                event.preventDefault();
            }
        });
    };
});

