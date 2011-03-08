var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
(function($) {
  $.julienTooltip = {
    version: '0.5'
  };
  return $.fn.julienTooltip = function(options) {
    var settings;
    settings = {
      location: 'right',
      theme: 'default',
      autoresize: false,
      event: 'click',
      template: '<div class="jt_wrapper">' + '<div class="jt_arrow"></div>' + '<a class="jt_close" href="#">Close</a>' + '<div class="jt_container">{content}</div>' + '</div>',
      arrowSize: {
        width: 15,
        height: 15
      }
    };
    if (!String.prototype.supplant) {
      String.prototype.supplant = function(o) {
        return this.replace(/{([^{}]*)}/g, function(a, b) {
          var r, _ref;
          r = o[b];
          if ((_ref = typeof r) === 'string' || _ref === 'number') {
            return r;
          } else {
            return a;
          }
        });
      };
    }
    return this.each(function() {
      var $arrow, $content, $overlay, closeAllTooltips, getLeft, getTop, matchedObject, shown, _ref;
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
        'position': 'relative',
        'z-index': 3000
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
      closeAllTooltips = function() {
        $('.jt_wrapper').hide();
        shown = false;
        $('.jt_overlay').remove();
        return false;
      };
      $(this).append($content);
      if (settings.autoresize) {
        $(this).find('.jt_wrapper').addClass('jt_autoresize');
      }
      $content.css({
        left: getLeft().content,
        top: getTop().content
      });
      $content.find('.jt_close').click(closeAllTooltips);
      $content.addClass('jt_location_' + settings.location);
      $arrow.css({
        left: getLeft().arrow,
        top: getTop().arrow,
        width: settings.arrowSize.width,
        height: settings.arrowSize.height
      });
      if ((_ref = settings.location) === 'top' || _ref === 'bottom') {
        $arrow.css({
          width: settings.arrowSize.height,
          height: settings.arrowSize.width
        });
      }
      $content.hide();
      if (settings.event === 'click') {
        return $(this).bind(settings.event, __bind(function(e) {
          closeAllTooltips();
          if (!shown) {
            $content.show();
            $('body').append($overlay);
            $overlay.css('height', $(document).height());
            if ($.fn.jScrollPane) {
              $content.find('.jt_container').jScrollPane();
            }
            $overlay.css('opacity', 0);
            $overlay.click(closeAllTooltips);
            shown = true;
          }
          return false;
        }, this));
      } else if (settings.event === 'mouseover') {
        $(this).bind('mouseover', __bind(function(e) {
          if (!shown) {
            $content.show();
            if ($.fn.jScrollPane) {
              $content.find('.jt_container').jScrollPane();
            }
            return shown = true;
          }
        }, this));
        return $(this).bind('mouseout', __bind(function(e) {
          if (shown) {
            closeAllTooltips();
            return shown = false;
          }
        }, this));
      }
    });
  };
})(jQuery);