(($) ->
  NivoSlider = (element, options) ->
    # Defaults are below
    settings = $.extend({}, $.fn.nivoSlider.defaults, options)
    # Useful variables. Play carefully.
    vars =
      currentSlide: 0
      currentImage: ''
      totalSlides: 0
      running: false
      paused: false
      stop: false
      controlNavEl: false
    # Get this slider
    slider = $(element)
    slider.data('nivo:vars', vars).addClass 'nivoSlider'
    # Find our slider children
    kids = slider.children()
    kids.each ->
      child = $(this)
      link = ''
      if !child.is('img')
        if child.is('a')
          child.addClass 'nivo-imageLink'
          link = child
        child = child.find('img:first')
      # Get img width & height
      childWidth = if childWidth == 0 then child.attr('width') else child.width()
      childHeight = if childHeight == 0 then child.attr('height') else child.height()
      if link != ''
        link.css 'display', 'none'
      child.css 'display', 'none'
      vars.totalSlides++
      return
    # If randomStart
    if settings.randomStart
      settings.startSlide = Math.floor(Math.random() * vars.totalSlides)
    # Set startSlide
    if settings.startSlide > 0
      if settings.startSlide >= vars.totalSlides
        settings.startSlide = vars.totalSlides - 1
      vars.currentSlide = settings.startSlide
    # Get initial image
    if $(kids[vars.currentSlide]).is('img')
      vars.currentImage = $(kids[vars.currentSlide])
    else
      vars.currentImage = $(kids[vars.currentSlide]).find('img:first')
    # Show initial link
    if $(kids[vars.currentSlide]).is('a')
      $(kids[vars.currentSlide]).css 'display', 'block'
    # Set first background
    sliderImg = $('<img/>').addClass('nivo-main-image')
    sliderImg.attr('src', vars.currentImage.attr('src')).show()
    slider.append sliderImg
    # Detect Window Resize
    $(window).resize ->
      slider.children('img').width slider.width()
      sliderImg.attr 'src', vars.currentImage.attr('src')
      sliderImg.stop().height 'auto'
      $('.nivo-slice').remove()
      $('.nivo-box').remove()
      return
    #Create caption
    slider.append $('<div class="nivo-caption"></div>')
    # Process caption function

    processCaption = (settings) ->
      nivoCaption = $('.nivo-caption', slider)
      if vars.currentImage.attr('title') != '' and vars.currentImage.attr('title') != undefined
        title = vars.currentImage.attr('title')
        if title.substr(0, 1) == '#'
          title = $(title).html()
        if nivoCaption.css('display') == 'block'
          setTimeout (->
            nivoCaption.html title
            return
          ), settings.animSpeed
        else
          nivoCaption.html title
          nivoCaption.stop().fadeIn settings.animSpeed
      else
        nivoCaption.stop().fadeOut settings.animSpeed
      return

    #Process initial  caption
    processCaption settings
    # In the words of Super Mario "let's a go!"
    timer = 0
    if !settings.manualAdvance and kids.length > 1
      timer = setInterval((->
        nivoRun slider, kids, settings, false
        return
      ), settings.pauseTime)
    # Add Direction nav
    if settings.directionNav
      slider.append '<div class="nivo-directionNav"><a class="nivo-prevNav">' + settings.prevText + '</a><a class="nivo-nextNav">' + settings.nextText + '</a></div>'
      $(slider).on 'click', 'a.nivo-prevNav', ->
        if vars.running
          return false
        clearInterval timer
        timer = ''
        vars.currentSlide -= 2
        nivoRun slider, kids, settings, 'prev'
        return
      $(slider).on 'click', 'a.nivo-nextNav', ->
        if vars.running
          return false
        clearInterval timer
        timer = ''
        nivoRun slider, kids, settings, 'next'
        return
    # Add Control nav
    if settings.controlNav
      vars.controlNavEl = $('<div class="nivo-controlNav"></div>')
      slider.after vars.controlNavEl
      i = 0
      while i < kids.length
        if settings.controlNavThumbs
          vars.controlNavEl.addClass 'nivo-thumbs-enabled'
          child = kids.eq(i)
          if !child.is('img')
            child = child.find('img:first')
          if child.attr('data-thumb')
            vars.controlNavEl.append '<a class="nivo-control" rel="' + i + '"><img src="' + child.attr('data-thumb') + '" alt="" /></a>'
        else
          vars.controlNavEl.append '<a class="nivo-control" rel="' + i + '">' + i + 1 + '</a>'
        i++
      #Set initial active link
      $('a:eq(' + vars.currentSlide + ')', vars.controlNavEl).addClass 'active'
      $('a', vars.controlNavEl).bind 'click', ->
        if vars.running
          return false
        if $(this).hasClass('active')
          return false
        clearInterval timer
        timer = ''
        sliderImg.attr 'src', vars.currentImage.attr('src')
        vars.currentSlide = $(this).attr('rel') - 1
        nivoRun slider, kids, settings, 'control'
        return
    #For pauseOnHover setting
    if settings.pauseOnHover
      slider.hover (->
        vars.paused = true
        clearInterval timer
        timer = ''
        return
      ), ->
        vars.paused = false
        # Restart the timer
        if timer == '' and !settings.manualAdvance
          timer = setInterval((->
            nivoRun slider, kids, settings, false
            return
          ), settings.pauseTime)
        return
    # Event when Animation finishes
    slider.bind 'nivo:animFinished', ->
      sliderImg.attr 'src', vars.currentImage.attr('src')
      vars.running = false
      # Hide child links
      $(kids).each ->
        if $(this).is('a')
          $(this).css 'display', 'none'
        return
      # Show current link
      if $(kids[vars.currentSlide]).is('a')
        $(kids[vars.currentSlide]).css 'display', 'block'
      # Restart the timer
      if timer == '' and !vars.paused and !settings.manualAdvance
        timer = setInterval((->
          nivoRun slider, kids, settings, false
          return
        ), settings.pauseTime)
      # Trigger the afterChange callback
      settings.afterChange.call this
      return

    # Add boxes for box animations

    createBoxes = (slider, settings, vars) ->
      if $(vars.currentImage).parent().is('a')
        $(vars.currentImage).parent().css 'display', 'block'
      $('img[src="' + vars.currentImage.attr('src') + '"]', slider).not('.nivo-main-image,.nivo-control img').width(slider.width()).css('visibility', 'hidden').show()
      boxWidth = Math.round(slider.width() / settings.boxCols)
      boxHeight = Math.round($('img[src="' + vars.currentImage.attr('src') + '"]', slider).not('.nivo-main-image,.nivo-control img').height() / settings.boxRows)
      rows = 0
      while rows < settings.boxRows
                cols = 0
        while cols < settings.boxCols
          if cols == settings.boxCols - 1
            slider.append $('<div class="nivo-box" name="' + cols + '" rel="' + rows + '"><img src="' + vars.currentImage.attr('src') + '" style="position:absolute; width:' + slider.width() + 'px; height:auto; display:block; top:-' + boxHeight * rows + 'px; left:-' + boxWidth * cols + 'px;" /></div>').css(
              opacity: 0
              left: boxWidth * cols + 'px'
              top: boxHeight * rows + 'px'
              width: slider.width() - (boxWidth * cols) + 'px')
            $('.nivo-box[name="' + cols + '"]', slider).height $('.nivo-box[name="' + cols + '"] img', slider).height() + 'px'
          else
            slider.append $('<div class="nivo-box" name="' + cols + '" rel="' + rows + '"><img src="' + vars.currentImage.attr('src') + '" style="position:absolute; width:' + slider.width() + 'px; height:auto; display:block; top:-' + boxHeight * rows + 'px; left:-' + boxWidth * cols + 'px;" /></div>').css(
              opacity: 0
              left: boxWidth * cols + 'px'
              top: boxHeight * rows + 'px'
              width: boxWidth + 'px')
            $('.nivo-box[name="' + cols + '"]', slider).height $('.nivo-box[name="' + cols + '"] img', slider).height() + 'px'
          cols++
        rows++
      sliderImg.stop().animate { height: $(vars.currentImage).height() }, settings.animSpeed
      return

    # Private run method

    nivoRun = (slider, kids, settings, nudge) ->
      `var i`
      `var vars`
      # Get our vars
      vars = slider.data('nivo:vars')
      # Trigger the lastSlide callback
      if vars and vars.currentSlide == vars.totalSlides - 1
        settings.lastSlide.call this
      # Stop
      if (!vars or vars.stop) and !nudge
        return false
      # Trigger the beforeChange callback
      settings.beforeChange.call this
      # Set current background before change
      if !nudge
        sliderImg.attr 'src', vars.currentImage.attr('src')
      else
        if nudge == 'prev'
          sliderImg.attr 'src', vars.currentImage.attr('src')
        if nudge == 'next'
          sliderImg.attr 'src', vars.currentImage.attr('src')
      vars.currentSlide++
      # Trigger the slideshowEnd callback
      if vars.currentSlide == vars.totalSlides
        vars.currentSlide = 0
        settings.slideshowEnd.call this
      if vars.currentSlide < 0
        vars.currentSlide = vars.totalSlides - 1
      # Set vars.currentImage
      if $(kids[vars.currentSlide]).is('img')
        vars.currentImage = $(kids[vars.currentSlide])
      else
        vars.currentImage = $(kids[vars.currentSlide]).find('img:first')
      # Set active links
      if settings.controlNav
        $('a', vars.controlNavEl).removeClass 'active'
        $('a:eq(' + vars.currentSlide + ')', vars.controlNavEl).addClass 'active'
      # Process caption
      processCaption settings
      # Remove any slices from last transition
      $('.nivo-slice', slider).remove()
      # Remove any boxes from last transition
      $('.nivo-box', slider).remove()
      currentEffect = settings.effect
      anims = ''
      # Generate random effect
      if settings.effect == 'random'
        anims = new Array('sliceDownRight', 'sliceDownLeft', 'sliceUpRight', 'sliceUpLeft', 'sliceUpDown', 'sliceUpDownLeft', 'fold', 'fade', 'boxRandom', 'boxRain', 'boxRainReverse', 'boxRainGrow', 'boxRainGrowReverse')
        currentEffect = anims[Math.floor(Math.random() * (anims.length + 1))]
        if currentEffect == undefined
          currentEffect = 'fade'
      # Run random effect from specified set (eg: effect:'fold,fade')
      if settings.effect.indexOf(',') != -1
        anims = settings.effect.split(',')
        currentEffect = anims[Math.floor(Math.random() * anims.length)]
        if currentEffect == undefined
          currentEffect = 'fade'
      # Custom transition as defined by "data-transition" attribute
      if vars.currentImage.attr('data-transition')
        currentEffect = vars.currentImage.attr('data-transition')
      # Run effects
      vars.running = true
      timeBuff = 0
      i = 0
      slices = ''
      firstSlice = ''
      totalBoxes = ''
      boxes = ''
      if currentEffect == 'sliceDown' or currentEffect == 'sliceDownRight' or currentEffect == 'sliceDownLeft'
        createSlices slider, settings, vars
        timeBuff = 0
        i = 0
        slices = $('.nivo-slice', slider)
        if currentEffect == 'sliceDownLeft'
          slices = $('.nivo-slice', slider)._reverse()
        slices.each ->
          slice = $(this)
          slice.css 'top': '0px'
          if i == settings.slices - 1
            setTimeout (->
              slice.animate { opacity: '1.0' }, settings.animSpeed, '', ->
                slider.trigger 'nivo:animFinished'
                return
              return
            ), 100 + timeBuff
          else
            setTimeout (->
              slice.animate { opacity: '1.0' }, settings.animSpeed
              return
            ), 100 + timeBuff
          timeBuff += 50
          i++
          return
      else if currentEffect == 'sliceUp' or currentEffect == 'sliceUpRight' or currentEffect == 'sliceUpLeft'
        createSlices slider, settings, vars
        timeBuff = 0
        i = 0
        slices = $('.nivo-slice', slider)
        if currentEffect == 'sliceUpLeft'
          slices = $('.nivo-slice', slider)._reverse()
        slices.each ->
          slice = $(this)
          slice.css 'bottom': '0px'
          if i == settings.slices - 1
            setTimeout (->
              slice.animate { opacity: '1.0' }, settings.animSpeed, '', ->
                slider.trigger 'nivo:animFinished'
                return
              return
            ), 100 + timeBuff
          else
            setTimeout (->
              slice.animate { opacity: '1.0' }, settings.animSpeed
              return
            ), 100 + timeBuff
          timeBuff += 50
          i++
          return
      else if currentEffect == 'sliceUpDown' or currentEffect == 'sliceUpDownRight' or currentEffect == 'sliceUpDownLeft'
        createSlices slider, settings, vars
        timeBuff = 0
        i = 0
        v = 0
        slices = $('.nivo-slice', slider)
        if currentEffect == 'sliceUpDownLeft'
          slices = $('.nivo-slice', slider)._reverse()
        slices.each ->
          slice = $(this)
          if i == 0
            slice.css 'top', '0px'
            i++
          else
            slice.css 'bottom', '0px'
            i = 0
          if v == settings.slices - 1
            setTimeout (->
              slice.animate { opacity: '1.0' }, settings.animSpeed, '', ->
                slider.trigger 'nivo:animFinished'
                return
              return
            ), 100 + timeBuff
          else
            setTimeout (->
              slice.animate { opacity: '1.0' }, settings.animSpeed
              return
            ), 100 + timeBuff
          timeBuff += 50
          v++
          return
      else if currentEffect == 'fold'
        createSlices slider, settings, vars
        timeBuff = 0
        i = 0
        $('.nivo-slice', slider).each ->
          slice = $(this)
          origWidth = slice.width()
          slice.css
            top: '0px'
            width: '0px'
          if i == settings.slices - 1
            setTimeout (->
              slice.animate {
                width: origWidth
                opacity: '1.0'
              }, settings.animSpeed, '', ->
                slider.trigger 'nivo:animFinished'
                return
              return
            ), 100 + timeBuff
          else
            setTimeout (->
              slice.animate {
                width: origWidth
                opacity: '1.0'
              }, settings.animSpeed
              return
            ), 100 + timeBuff
          timeBuff += 50
          i++
          return
      else if currentEffect == 'fade'
        
        firstSlice = $('.nivo-slice:first', slider)
        firstSlice.css 'width': slider.width() + 'px'
        firstSlice.animate { opacity: '1.0' }, settings.animSpeed * 2, '', ->
          slider.trigger 'nivo:animFinished'
          return
      else if currentEffect == 'slideInRight'
        createSlices slider, settings, vars
        firstSlice = $('.nivo-slice:first', slider)
        firstSlice.css
          'width': '0px'
          'opacity': '1'
        firstSlice.animate { width: slider.width() + 'px' }, settings.animSpeed * 2, '', ->
          slider.trigger 'nivo:animFinished'
          return
      else if currentEffect == 'slideInLeft'
        createSlices slider, settings, vars
        firstSlice = $('.nivo-slice:first', slider)
        firstSlice.css
          'width': '0px'
          'opacity': '1'
          'left': ''
          'right': '0px'
        firstSlice.animate { width: slider.width() + 'px' }, settings.animSpeed * 2, '', ->
          # Reset positioning
          firstSlice.css
            'left': '0px'
            'right': ''
          slider.trigger 'nivo:animFinished'
          return
      else if currentEffect == 'boxRandom'
        createBoxes slider, settings, vars
        totalBoxes = settings.boxCols * settings.boxRows
        i = 0
        timeBuff = 0
        boxes = shuffle($('.nivo-box', slider))
        boxes.each ->
          box = $(this)
          if i == totalBoxes - 1
            setTimeout (->
              box.animate { opacity: '1' }, settings.animSpeed, '', ->
                slider.trigger 'nivo:animFinished'
                return
              return
            ), 100 + timeBuff
          else
            setTimeout (->
              box.animate { opacity: '1' }, settings.animSpeed
              return
            ), 100 + timeBuff
          timeBuff += 20
          i++
          return
      else if currentEffect == 'boxRain' or currentEffect == 'boxRainReverse' or currentEffect == 'boxRainGrow' or currentEffect == 'boxRainGrowReverse'
        createBoxes slider, settings, vars
        totalBoxes = settings.boxCols * settings.boxRows
        i = 0
        timeBuff = 0
        # Split boxes into 2D array
        rowIndex = 0
        colIndex = 0
        box2Darr = []
        box2Darr[rowIndex] = []
        boxes = $('.nivo-box', slider)
        if currentEffect == 'boxRainReverse' or currentEffect == 'boxRainGrowReverse'
          boxes = $('.nivo-box', slider)._reverse()
        boxes.each ->
          box2Darr[rowIndex][colIndex] = $(this)
          colIndex++
          if colIndex == settings.boxCols
            rowIndex++
            colIndex = 0
            box2Darr[rowIndex] = []
          return
        # Run animation
        cols = 0
        while cols < settings.boxCols * 2
          prevCol = cols
          rows = 0
          while rows < settings.boxRows
            if prevCol >= 0 and prevCol < settings.boxCols

              ### Due to some weird JS bug with loop vars
              being used in setTimeout, this is wrapped
              with an anonymous function call
              ###

              ((row, col, time, i, totalBoxes) ->
                box = $(box2Darr[row][col])
                w = box.width()
                h = box.height()
                if currentEffect == 'boxRainGrow' or currentEffect == 'boxRainGrowReverse'
                  box.width(0).height 0
                if i == totalBoxes - 1
                  setTimeout (->
                    box.animate {
                      opacity: '1'
                      width: w
                      height: h
                    }, settings.animSpeed / 1.3, '', ->
                      slider.trigger 'nivo:animFinished'
                      return
                    return
                  ), 100 + time
                else
                  setTimeout (->
                    box.animate {
                      opacity: '1'
                      width: w
                      height: h
                    }, settings.animSpeed / 1.3
                    return
                  ), 100 + time
                return
              ) rows, prevCol, timeBuff, i, totalBoxes
              i++
            prevCol--
            rows++
          timeBuff += 100
          cols++
      return

    # Shuffle an array

    shuffle = (arr) ->
      `var i`
      j = undefined
      x = undefined
      i = arr.length
      while i
        j = parseInt(Math.random() * i, 10)
        x = arr[--i]
        arr[i] = arr[j]
        arr[j] = x
      arr

    # For debugging

    trace = (msg) ->
      if @console and typeof console.log != 'undefined'
        console.log msg
      return

    # Start / Stop

    @stop = ->
      if !$(element).data('nivo:vars').stop
        $(element).data('nivo:vars').stop = true
        trace 'Stop Slider'
      return

    @start = ->
      if $(element).data('nivo:vars').stop
        $(element).data('nivo:vars').stop = false
        trace 'Start Slider'
      return

    # Trigger the afterLoad callback
    settings.afterLoad.call this
    this

  $.fn.nivoSlider = (options) ->
    @each (key, value) ->
      element = $(this)
      # Return early if this element already has a plugin instance
      if element.data('nivoslider')
        return element.data('nivoslider')
      # Pass options to plugin constructor
      nivoslider = new NivoSlider(this, options)
      # Store plugin object in this element's data
      element.data 'nivoslider', nivoslider
      return

  #Default settings
  $.fn.nivoSlider.defaults =
    effect: 'random'
    slices: 15
    boxCols: 8
    boxRows: 4
    animSpeed: 500
    pauseTime: 3000
    startSlide: 0
    directionNav: true
    controlNav: true
    controlNavThumbs: false
    pauseOnHover: true
    manualAdvance: false
    prevText: 'Prev'
    nextText: 'Next'
    randomStart: false
    beforeChange: ->
    afterChange: ->
    slideshowEnd: ->
    lastSlide: ->
    afterLoad: ->
  $.fn._reverse = [].reverse
  return
) $
