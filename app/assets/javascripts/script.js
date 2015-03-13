function addInfoWindows(map) {
  $.ajax({
    type: 'GET',
    url: '/',
    dataType: 'json'
  })
  .done(function(response){
    $.each(response, function(index, dream){
      var position = new google.maps.LatLng(dream.location_lat, dream.location_long);
      var marker = new google.maps.Marker({
        position: position,
        map: map,
        title: dream.title
      });
      
      var infoWindowContent = '<div id="info-window-content"><img src="' + dream.dream_image.url + '"><h5>' + dream.title + '</h5><p>' + dream.description + '</p></div>';

      var infowindow = new google.maps.InfoWindow({
          content: infoWindowContent
      });
      google.maps.event.addListener(marker, 'click', function() {
        $('*[id*=info-window-content]:visible').each(function() {
          $(this).parent().parent().parent().parent().hide();
        });
        infowindow.open(map, marker);
      });
    });
  });
}

function initMap() {
  var mapOptions = {
    center: new google.maps.LatLng(30, -25),
    zoom: 3,
    disableDefaultUI: true,

    styles: [{"featureType":"administrative","elementType":"all","stylers":[{"visibility":"on"},{"lightness":33}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2e5d4"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#c5dac6"}]},{"featureType":"poi.park","elementType":"labels","stylers":[{"visibility":"on"},{"lightness":20}]},{"featureType":"road","elementType":"all","stylers":[{"lightness":20}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#c5c6c6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#e4d7c6"}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#fbfaf7"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"on"},{"color":"#acbcc9"}]}],
  };
  var map = new google.maps.Map(document.getElementById('map-container'), mapOptions);
  addInfoWindows(map);
  google.maps.event.addListener(map, 'click', function(event) {
    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(event.latLng.k, event.latLng.D),
        map: map,
        title: 'newLocation'
      });
    $('#lat-field').val(event.latLng.k)
    $('#long-field').val(event.latLng.D)
  });
}

$(document).ready(function() {
  google.maps.event.addDomListener(window, 'load', initMap)

  $('#form').hide()

  $('.close').click(function() {
    $('#about').hide()
    $('#form').show()
  })

  $('#toggle-form').click(function() {
    $('#form').toggleClass('collapsed')
  })

  $("#no-action").click(function () {
    return false;
  });

})