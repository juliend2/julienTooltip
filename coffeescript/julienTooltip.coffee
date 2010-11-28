# watch with : coffee -wbc -o js/ coffeescript/*.coffee

(( $ )->

  $.fn.julienTooltip = (options)->
    
    settings =
      location: 'right'
      theme:    'default'
      event:    'click' # click, TODO: Add hover option
      template: '<div class="jt_wrapper">'+
        '<div class="jt_arrow"></div>'+
        '<a class="jt_close" href="#">Close</a>'+
        '<div class="jt_container">{content}</div>'+
        '</div>'
      arrowSize:
        width: 15
        height: 15
    
    # overload some prototypes
    unless String.prototype.supplant
      String.prototype.supplant = (o)->
        @replace /{([^{}]*)}/g , (a, b)->
          r = o[b]
          if typeof r in ['string','number'] then r else a
          
    # And now the plugin's stuff...
    @each ->
      
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
        unless shown then return false
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
      $content.addClass('jt_location_'+settings.location)
      # arrow attributes
      $arrow.css
        left:   getLeft().arrow
        top:    getTop().arrow
        width:  settings.arrowSize.width
        height: settings.arrowSize.height
      # top and bottom are special cases
      if settings.location in ['top', 'bottom']
        $arrow.css
          width: settings.arrowSize.height
          height: settings.arrowSize.width
      # setup the events
      $content.hide()
      $(this).bind settings.event, (e)=>
        unless shown
          $content.show()
          $('body').append $overlay
          $overlay.css('height', $(document).height())
          $overlay.click closeTooltip
          shown = true
        false
      
) jQuery
