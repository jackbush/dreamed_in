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
      
      var infoWindowContent = '<div id="info-window-content"><a href="' + window.location.origin + '/dreams/' + dream.id + '"><h4>' + dream.title + '</h4></a><img src="' + dream.dream_image.url + '"><p>' + dream.description + '</p></div>';

      var infowindow = new google.maps.InfoWindow({
          content: infoWindowContent
      });
      google.maps.event.addListener(marker, 'click', function() {
        // close any current infowindows -- is there a close function?
        $('#info-window-content').hide();
        infowindow.open(map, marker);
      });
    });
  });
}

function initMap() {
  var mapOptions = {
    center: new google.maps.LatLng(20.519889, -0.068799),
    zoom: 6,

    styles: [{"featureType":"administrative","elementType":"all","stylers":[{"visibility":"on"},{"lightness":33}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2e5d4"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#c5dac6"}]},{"featureType":"poi.park","elementType":"labels","stylers":[{"visibility":"on"},{"lightness":20}]},{"featureType":"road","elementType":"all","stylers":[{"lightness":20}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#c5c6c6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#e4d7c6"}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#fbfaf7"}]},{"featureType":"water","elementType":"all","stylers":[{"visibility":"on"},{"color":"#acbcc9"}]}],
  };
  var map = new google.maps.Map(document.getElementById('map-container'), mapOptions);
  addInfoWindows(map);
  google.maps.event.addListener(map, 'click', function(event) {
    console.log(event.latLng);
    // clear any current instance of the below marker
    // or clear all markers and move :51 way down
    var marker = new google.maps.Marker({
        // set marker icon to some different
        // is there a marker id arg?
        position: new google.maps.LatLng(event.latLng),
        map: map,
      });
    $('#lat-field').val('hi')
    $('#long-field').text('hi')
  });
}

$(document).ready(function() {
  google.maps.event.addDomListener(window, 'load', initMap)

  $('button#toggle-index-map').click(function() {
    $("#map-container").toggleClass('hide-map');
    $("#homepage").toggleClass('hide-homepage');
  });

  // changing new dream creation to an ajax request
  // $('button#new-dream-button').click(function(event) {
  //   event.preventDefault()
  //   
  // });

})


// center on user by adding this after info windows
// if (navigator.geolocation) {
//     navigator.geolocation.getCurrentPosition(function (position) {
//        initialLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
//        map.setCenter(initialLocation);
//        smoothZoom(map, 13, 8);
//     });
//   }