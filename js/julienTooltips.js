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
    if (!String.prototype.supplant) {
      String.prototype.supplant = function(o) {
        return this.replace(/{([^{}]*)}/g, function(a, b) {
          var r;
          r = o[b];
          if (typeof r === 'string' || typeof r === 'number') {
            return r;
          } else {
            return a;
          }
        });
      };
    }
    return this.each(function() {
      var $content, $overlay, closeTooltip, getLeft, getTop, matchedObject, shown;
      shown = false;
      matchedObject = this;
      if (options) {
        $.extend(settings, options);
      }
      $content = $('<div class="jt_container"><div class="jt_content">' + settings.content + '</div></div>');
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