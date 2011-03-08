(( $ )->
  $.julienTooltip = version: '0.5'
  
  $.fn.julienTooltip = (options)->
    
    settings =
      location: 'right'
      theme:    'default',
      autoresize: false,
      event:    'click' # click, mouseover
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
        'z-index':3000
      
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
          
      closeAllTooltips = ->
        $('.jt_wrapper').hide()
        shown = false
        $('.jt_overlay').remove()
        return false
      
      # setup the content div
      $(this).append $content
      if settings.autoresize
        $(this).find('.jt_wrapper').addClass('jt_autoresize')
      $content.css
        left: getLeft().content
        top:  getTop().content
      $content.find('.jt_close').click closeAllTooltips
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
      if settings.event == 'click'
        $(this).bind settings.event, (e)=>
          closeAllTooltips()
          unless shown
            $content.show()
            $('body').append $overlay
            $overlay.css('height', $(document).height())
            if $.fn.jScrollPane
              $content.find('.jt_container').jScrollPane()
            $overlay.css('opacity',0)
            $overlay.click closeAllTooltips
            shown = true
          false
      else if settings.event == 'mouseover'
        $(this).bind 'mouseover', (e)=>
          unless shown
            $content.show()
            if $.fn.jScrollPane
              $content.find('.jt_container').jScrollPane()
            shown = true
        $(this).bind 'mouseout', (e)=>
          if shown
            closeAllTooltips()
            shown = false
      
) jQuery
