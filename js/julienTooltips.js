var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
(function($) {
  return $.fn.julienTooltips = function(options) {
    var settings;
    settings = {
      location: 'top',
      theme: 'default',
      content: "(your tooltip's content)",
      event: 'click',
      closeBtn: '<a class="" href="#">Close</a>'
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
      $content = $('<div class="jt_container"><a class="jt_close" href="#">Close</a><div class="jt_content">{content}</div></div>'.supplant({
        content: settings.content
      }));
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
        $('.jt_overlay').remove();
        return false;
      };
      $(this).append($content);
      $content.css({
        'left': getLeft(),
        'top': getTop()
      });
      $content.find('.jt_close').click(closeTooltip);
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