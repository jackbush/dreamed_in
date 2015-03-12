function smoothZoom (map, max, cnt) {
  if (cnt >= max) {
      return;
    }
  else {
    z = google.maps.event.addListener(map, 'zoom_changed', function(event){
        google.maps.event.removeListener(z);
        smoothZoom(map, max, cnt + 1);
    });
    setTimeout(function(){map.setZoom(cnt)}, 80);
  }
}

function addInfoWindows(map) {
  var geocoder = new google.maps.Geocoder();
  var showMarkerFromGeocoderResults = function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var position = results[0].geometry.location
      var marker = new google.maps.Marker({
        map: map,
        position: position
      });
      map.setCenter(position);
    };
  };

  $.ajax({
    type: 'GET',
    url: '/',
    dataType: 'json'
  })
  .done(function(response){
    $.each(response, function(index, dream){
      var geocoderOptions = { address: dream.postcode };
      geocoder.geocode( geocoderOptions, showMarkerFromGeocoderResults)
    });

    var marker = new google.maps.Marker({
      position: position,
      map: map,
      title: dream.title
    });

    var infoWindowContent = '<div id="info-window-container">' + '<a href="/dreams/' + dream.id + '"><h3>' + dream.title + '</h3></a><p>' + dream.description + '</p></div>';
    
    var infowindow = new google.maps.InfoWindow({
        content: infoWindowContent
    });
    
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });
  });
};

function initMap() {

  console.log('map')

  var mapOptions = {
    center: new google.maps.LatLng(51.519889, -0.068799),
    zoom: 15,

    styles: [{"featureType":"administrative","elementType":"all","stylers":[{"visibility":"on"},{"lightness":33}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2e5d4"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#c5dac6"}]},{"featureType":"poi.park","elementType":"labels","stylers":[{"visibility":"on"},{"lightness":20}]},{"featureType":"road","elementType":"all","stylers":[{"lightness":20}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#c5c6c6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#e4d7c6"}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#fbfaf7"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"on"},{"color":"#acbcc9"}]}],

  };
  var map = new google.maps.Map(document.getElementById('map-container'), mapOptions);
  // addInfoWindows(map);
}

// center on user by adding this after info windows
// if (navigator.geolocation) {
//     navigator.geolocation.getCurrentPosition(function (position) {
//        initialLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
//        map.setCenter(initialLocation);
//        smoothZoom(map, 13, 8);
//     });
//   }

$(document).ready(function() {
  google.maps.event.addDomListener(window, 'load', initMap)
})
