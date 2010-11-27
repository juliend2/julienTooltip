# watch with : coffee -wbc -o js/ coffeescript/*.coffee

(( $ )->

  $.fn.julienTooltips = (options)->
    
    settings =
      location: 'top'
      theme:    'default'
      event:    'click' # click, hover (TODO)
      closeBtn: '<a class="" href="#">Close</a>'
    
    # Crockford's String.supplant()
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
        
      $content = $('<div class="jt_wrapper"><a class="jt_close" href="#">Close</a><div class="jt_container">{content}</div></div>'.supplant
        content:$(this).find('.jt_content').html()
        )
      $overlay = $('<div class="jt_overlay"></div>')
      
      $(this).css 
        'position':'relative'
        
      getLeft = ->
        if settings.location == 'right' then $(matchedObject).outerWidth() else 0
        
      getTop = ->
        if settings.location == 'bottom' then $(matchedObject).outerHeight() else 0
      
      closeTooltip = ->
        if not shown then return false
        $content.hide()
        shown = false
        $('.jt_overlay').remove()
        return false
      
      # setup the content div
      $(this).append $content
      $content.css
        'left': getLeft()
        'top':  getTop()
      $content.find('.jt_close').click closeTooltip
      
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
