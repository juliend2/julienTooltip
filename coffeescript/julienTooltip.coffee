# watch with : coffee -wbc -o js/ coffeescript/*.coffee

(( $ )->

  $.fn.julienTooltip = (options)->
    
    settings =
      location: 'right'
      theme:    'default'
      event:    'click' # click, hover (TODO)
      template: '<div class="jt_wrapper">'+
        '<div class="jt_arrow"></div>'+
        '<a class="jt_close" href="#">Close</a>'+
        '<div class="jt_container">{content}</div>'+
        '</div>'
      arrowSize:
        width: 10
        height: 30
    
    # overload some prototypes
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
        
      $content = $(settings.template.supplant
        content: $(this).find('.jt_content').html()
        )
      $overlay = $('<div class="jt_overlay"></div>')
      $arrow = $content.find('.jt_arrow')
      
      $(this).css 
        'position':'relative'
      
      # some functions...
      getLeft = ->
        if settings.location == 'right'
          content: $(matchedObject).outerWidth() + settings.arrowSize.width
          arrow:   -settings.arrowSize.width 
        else if settings.location == 'left'
          content: -$content.outerWidth() - settings.arrowSize.width
          arrow:   $content.outerWidth()
        else if settings.location == 'bottom'
          content: -($content.outerWidth() - $(matchedObject).outerWidth()) / 2
          arrow: ($content.outerWidth() - settings.arrowSize.height)/2
        else if settings.location == 'top'
          content: -($content.outerWidth() - $(matchedObject).outerWidth()) / 2
          arrow: ($content.outerWidth() - settings.arrowSize.height)/2
        
      getTop = ->
        if settings.location == 'bottom'
          content: $(matchedObject).outerHeight() + settings.arrowSize.width
          arrow:   -settings.arrowSize.width
        else if settings.location == 'top'
          content: -$content.outerHeight() - settings.arrowSize.width
          arrow:   $content.outerHeight()
        else if settings.location == 'right'
          content: -($content.outerHeight() - $(matchedObject).outerHeight()) / 2
          arrow: ($content.outerHeight() - settings.arrowSize.height)/2
        else if settings.location == 'left'
          content: -($content.outerHeight() - $(matchedObject).outerHeight()) / 2
          arrow: ($content.outerHeight() - settings.arrowSize.height)/2
          
      closeTooltip = ->
        if not shown then return false
        $content.hide()
        shown = false
        $('.jt_overlay').remove()
        return false
      
      # setup the content div
      $(this).append $content
      $content.css
        left: getLeft().content
        top:  getTop().content
      $content.find('.jt_close').click closeTooltip
      # arrow attributes
      $arrow.css
        left:   getLeft().arrow
        top:    getTop().arrow
        width:  settings.arrowSize.width
        height: settings.arrowSize.height
      # top and bottom are special cases
      if settings.location is 'top' or settings.location is 'bottom'
        $arrow.css
          width: settings.arrowSize.height
          height: settings.arrowSize.width
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
