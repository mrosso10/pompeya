angular.module('filtrosPresupuestador', [])
.filter 'hora', ->
  (input) ->
    pad(Math.floor(input / 100), 2) + ":" + pad(input % 100, 2)
.filter 'horaVerbosa', (horaFilter) ->
  (input) ->
    horaFilter(input) + ' hs'
.filter 'moneda', ->
  (input) ->
    float = parseFloat(input)
    return '' if isNaN(float)
    '$ ' + float.toFixed(2)
.filter 'precioServicio', (monedaFilter) ->
  (input) ->
    monedaFilter(input)
.filter 'isEmpty', ->
  (input) ->
    angular.equals({}, input)
.filter 'isAlphabetic', ->
  (input) ->
    return false unless input
    isNaN(parseInt(input))
.filter 'float', ->
  (input) ->
    float = parseFloat(input)
    if isNaN(float) then 0 else float
.filter 'removeAccents', ->
  (source) ->
    accents = [
      /[\300-\306]/g, /[\340-\346]/g, # A, a
      /[\310-\313]/g, /[\350-\353]/g, # E, e
      /[\314-\317]/g, /[\354-\357]/g, # I, i
      /[\322-\330]/g, /[\362-\370]/g, # O, o
      /[\331-\334]/g, /[\371-\374]/g, # U, u
      /[\321]/g, /[\361]/g, # N, n
      /[\307]/g, /[\347]/g, # C, c
    ]
    noaccent = ['A','a','E','e','I','i','O','o','U','u','N','n','C','c']
    for accent, i in accents
      source = source.replace(accent, noaccent[i])
    source
