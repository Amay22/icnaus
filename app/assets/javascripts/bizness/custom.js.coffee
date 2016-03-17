# navigation script for responsive
ww = $(window).width()
$(document).ready ->
  $('nav#nav li a').each ->
    if $(this).next().length > 0
      $(this).addClass 'parent'
    return

$(document).ready ->
  if $('#slider').length > 0
    $('.nivoSlider').nivoSlider
      effect: 'fade'
      animSpeed: 500
      pauseTime: 3000
      startSlide: 0
  return
