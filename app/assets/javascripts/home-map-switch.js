$(document).ready(function() {

  $('button#toggle-index-map').click(function() {
    $("#map-container").toggleClass('hide-map');
    $("#homepage").toggleClass('hide-homepage');
  });
});