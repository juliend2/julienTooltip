var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
(function($) {
  return $.fn.julienTooltip = function(options) {
    var settings;
    settings = {
      location: 'right',
      theme: 'default',
      event: 'click',
      template: '<div class="jt_wrapper">' + '<div class="jt_arrow"></div>' + '<a class="jt_close" href="#">Close</a>' + '<div class="jt_container">{content}</div>' + '</div>',
      arrowSize: {
        width: 10,
        height: 30
      }
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
      var $arrow, $content, $overlay, closeTooltip, getLeft, getTop, matchedObject, shown;
      shown = false;
      matchedObject = this;
      if (options) {
        $.extend(settings, options);
      }
      $content = $(settings.template.supplant({
        content: $(this).find('.jt_content').html()
      }));
      $overlay = $('<div class="jt_overlay"></div>');
      $arrow = $content.find('.jt_arrow');
      $(this).css({
        'position': 'relative'
      });
      getLeft = function() {
        if (settings.location === 'right') {
          return {
            content: $(matchedObject).outerWidth() + settings.arrowSize.width,
            arrow: -settings.arrowSize.width
          };
        } else if (settings.location === 'left') {
          return {
            content: -$content.outerWidth() - settings.arrowSize.width,
            arrow: $content.outerWidth()
          };
        } else if (settings.location === 'bottom') {
          return {
            content: -($content.outerWidth() - $(matchedObject).outerWidth()) / 2,
            arrow: ($content.outerWidth() - settings.arrowSize.height) / 2
          };
        } else if (settings.location === 'top') {
          return {
            content: -($content.outerWidth() - $(matchedObject).outerWidth()) / 2,
            arrow: ($content.outerWidth() - settings.arrowSize.height) / 2
          };
        }
      };
      getTop = function() {
        if (settings.location === 'bottom') {
          return {
            content: $(matchedObject).outerHeight() + settings.arrowSize.width,
            arrow: -settings.arrowSize.width
          };
        } else if (settings.location === 'top') {
          return {
            content: -$content.outerHeight() - settings.arrowSize.width,
            arrow: $content.outerHeight()
          };
        } else if (settings.location === 'right') {
          return {
            content: -($content.outerHeight() - $(matchedObject).outerHeight()) / 2,
            arrow: ($content.outerHeight() - settings.arrowSize.height) / 2
          };
        } else if (settings.location === 'left') {
          return {
            content: -($content.outerHeight() - $(matchedObject).outerHeight()) / 2,
            arrow: ($content.outerHeight() - settings.arrowSize.height) / 2
          };
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
        left: getLeft().content,
        top: getTop().content
      });
      $content.find('.jt_close').click(closeTooltip);
      $arrow.css({
        left: getLeft().arrow,
        top: getTop().arrow,
        width: settings.arrowSize.width,
        height: settings.arrowSize.height
      });
      if (settings.location === 'top' || settings.location === 'bottom') {
        $arrow.css({
          width: settings.arrowSize.height,
          height: settings.arrowSize.width
        });
      }
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