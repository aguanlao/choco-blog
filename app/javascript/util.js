$(document).on('turbolinks:load', function() {
  var popoverWhitelist = $.fn.tooltip.Constructor.Default.whiteList;

  // Must whitelist attributes for popovers' elements
  popoverWhitelist.button = ["data-copy-text", "data-target"];
  popoverWhitelist.a.push(...["rel", "data-confirm", "data-method"]);

  $('[data-toggle="popover"]').each(function() {
    var source = "div#" + $(this).attr("data-source");
    $(this).popover({
      html: true,
      content: function() {
        return $(source).html();
      },
      whiteList: popoverWhitelist
    });
  });

  $('[data-toggle="popover"]').click(() => {
    // Bind copy button to toggle result tooltip with proper message
    $('[data-target^="copy"]').click(function() {
      var tooltipText = $(this).data("copyText");
      var tooltipTarget = "#" + $(this).attr("data-target");
      var copyResult = copyText(tooltipText);
      var message = copyResult ? "Link copied to clipboard" : "Copy failed";

      $(tooltipTarget).attr("data-original-title", message).tooltip('toggle');
      setTimeout(() => $(tooltipTarget).tooltip('hide'), 1000);
    });
  });
  
  $('[data-toggle="copy-tooltip"]').tooltip({
    template: '<div class="tooltip copy-tooltip" role="tooltip"><div class="tooltip-inner"></div></div>',
    trigger: "manual",
    offset: -100
  });

  if ($('body').hasClass("posts")) {
    var categoryIds = $('#categories').data("ids");
    var categorySelect = $('select.select-2');
    console.log(categoryIds);
    // Remove leftover select2 components left by turbolinks
    if (categorySelect.hasClass("select2-hidden-accessible")) {
      $('span.select2-container.select2-container--bootstrap4').remove();
      $('.select2-container--open').remove();
    }
    
    categorySelect.select2({
      theme: "bootstrap4"
    }).val(categoryIds).trigger('change');
  }
});

function copyText(text) {
  var textArea = document.createElement("textarea");
  var successful;

  textArea.style.position = 'fixed';
  textArea.style.top = 0;
  textArea.style.left = 0;
  textArea.style.width = '2em';
  textArea.style.height = '2em';
  textArea.style.padding = 0;
  textArea.style.border = 'none';
  textArea.style.outline = 'none';
  textArea.style.boxShadow = 'none';
  textArea.style.background = 'transparent';

  textArea.value = text;

  document.body.appendChild(textArea);
  textArea.focus();
  textArea.select();
  try {
    successful = document.execCommand('copy');
  } catch (err) {
    console.error('Failed to copy text to clipboard.');
  }

  document.body.removeChild(textArea);
  return successful;
}