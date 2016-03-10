# navigation script for responsive
ww = jQuery(window).width()
jQuery(document).ready ->
  jQuery('nav#nav li a').each ->
    if jQuery(this).next().length > 0
      jQuery(this).addClass 'parent'
    return
  jQuery('.mobile_nav a').click (e) ->
    e.preventDefault()
    jQuery(this).toggleClass 'active'
    jQuery('nav#nav').slideToggle 'fast'
    return
  adjustMenu()
  return
# navigation orientation resize callbak
jQuery(window).bind 'resize orientationchange', ->
  ww = jQuery(window).width()
  adjustMenu()
  return
# navigation function for responsive

adjustMenu = ->
  if ww < 768
    jQuery('.mobile_nav a').css 'display', 'block'
    if !jQuery('.mobile_nav a').hasClass('active')
      jQuery('nav#nav').hide()
    else
      jQuery('nav#nav').show()
    jQuery('nav#nav li').unbind 'mouseenter mouseleave'
  else
    jQuery('.mobile_nav a').css 'display', 'none'
    jQuery('nav#nav').show()
    jQuery('nav#nav li').removeClass 'hover'
    jQuery('nav#nav li a').unbind 'click'
    jQuery('nav#nav li').unbind('mouseenter mouseleave').bind 'mouseenter mouseleave', ->
      jQuery(this).toggleClass 'hover'
      return
  return

jQuery(document).ready ->
  if jQuery('#slider').length > 0
    jQuery('.nivoSlider').nivoSlider
      effect: 'fade'
      animSpeed: 500
      pauseTime: 3000
      startSlide: 0
  return
