# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ () ->
  
  $textArea = $('.js-text-area')
  $textCounter = $('.js-count-text')
  
  if $textArea.length > 0
    $textCounter.text $textArea.val().length
  
  $textArea.on 'keyup keydown', ->
    # console.log $(@).val().length
    textVal = $(@).val().length
    $textCounter.text textVal
    if textVal > 140
      $textCounter.css 'color', '#f00'
    else
      $textCounter.removeAttr 'style'