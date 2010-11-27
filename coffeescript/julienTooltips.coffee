# watch with : coffee -wbc -o js/ coffeescript/*.coffee

(( $ )->

  $.fn.julienTooltips = (options)->
    
    settings =
      location: 'top'
      theme:    'default'
      content:  "(your tooltip's content)"
      event:    'click' # click, hover (TODO)
    
    # here's some crockford awesomeness...
    if not String.prototype.supplant
      String.prototype.supplant = (o)->
        this.replace /{([^{}]*)}/g , (a, b)->
          r = o[b]
          if typeof r is 'string' or typeof r is 'number' then r else a
    
    # And now the plugin's stuff...
    this.each ->
    
      shown = false
      matchedObject = this
      
      # merge settings :
      if options
        $.extend settings, options
        
      $content = $('<div class="jt_container"><div class="jt_content">'+settings.content+'</div></div>')
      $overlay = $('<div class="jt_overlay"></div>')
      
      $(this).css 
        'position':'relative'
        
      getLeft = ->
        if settings.location == 'right' then $(matchedObject).width() else 0
        
      getTop = ->
        if settings.location == 'bottom' then $(matchedObject).height() else 0
      
      closeTooltip = ->
        if not shown then return false
        $content.hide()
        shown = false
        $('.jt_overlay').remove()
      
      # setup the content div
      $(this).append $content
      $content.css
        'left': getLeft()
        'top':  getTop()
        
      # setup the events
      $content.hide()
      $(this).bind settings.event, (e)=>
        if not shown
          $content.show()
          $('body').append $overlay
          $overlay.click closeTooltip
          shown = true
        false
      
) jQuery
