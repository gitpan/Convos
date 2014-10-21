;(function($) {
  window.convos = window.convos || {};

  convos.conversations = {
    add: function($e) {
      var url = $.url_for($e.attr('data-network'), encodeURIComponent($e.attr('data-target')));
      $.pjax({ url: url, container: 'div.messages', fragment: 'div.messages'});
    },
    remove: function($e) {
      var url = $.url_for($e.attr('data-network'), encodeURIComponent($e.attr('data-target')));
      var active = false;

      $('nav ul.conversations a').slice(1).each(function(i) {
        if (this.href.indexOf(url) == -1) return;
        if (!active) active = $(this).hasClass('active');
        $(this).remove();
      });

      if (active) {
        $('nav ul.conversations a').slice(0, 2).get().reverse()[0].click();
      }
    }
  };

  $(document).ready(function() {
    var pos = 0;
    var t;
    $(window)
      .on('blur', function() {
        if (!pos) pos = $('div.messages li').length;
        clearTimeout(t);
      })
      .on('focus', function() {
        t = setTimeout(function() { pos = 0; }, 10000);
        $('div.messages li').removeClass('history-starting-point').eq(pos).addClass('history-starting-point');
      });
  });
})(jQuery);
