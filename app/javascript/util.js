$(document).on('turbolinks:load', function () {
  var popoverWhitelist = $.fn.tooltip.Constructor.Default.whiteList;

  popoverWhitelist.a.push(...["rel", "data-confirm", "data-method"]);

  $('[data-toggle="popover"]').each(function () {
    var source = "div#" + $(this).attr("data-source");
    $(this).popover({
      html: true,
      content: function () {
        return $(source).html();
      },
      whiteList: popoverWhitelist
    });
  });
});