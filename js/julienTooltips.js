var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
(function($) {
  return $.fn.julienTooltips = function(options) {
    var settings;
    settings = {
      location: 'top',
      theme: 'default',
      content: "(your tooltip's content)",
      event: 'click'
    };
    return this.each(function() {
      var $content, $overlay, closeTooltip, getLeft, getTop, matchedObject, shown;
      shown = false;
      matchedObject = this;
      if (options) {
        $.extend(settings, options);
      }
      $content = $('<div class="julienTooltips">' + settings.content + '</div>');
      $overlay = $('<div class="jt_overlay"></div>');
      $(this).css({
        'position': 'relative'
      });
      getLeft = function() {
        if (settings.location === 'right') {
          return $(matchedObject).width();
        } else {
          return 0;
        }
      };
      getTop = function() {
        if (settings.location === 'bottom') {
          return $(matchedObject).height();
        } else {
          return 0;
        }
      };
      closeTooltip = function() {
        if (!shown) {
          return false;
        }
        $content.hide();
        shown = false;
        return $('.jt_overlay').remove();
      };
      $(this).append($content);
      $content.css({
        'left': getLeft(),
        'top': getTop()
      });
      $content.hide();
      return $(this).bind(settings.event, __bind(function(e) {
        if (!shown) {
          $content.show();
          $('body').append($overlay);
          $overlay.click(closeTooltip);
          shown = true;
        }
        return false;
      }, this));
    });
  };
})(jQuery);