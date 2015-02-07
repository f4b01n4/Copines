// This example displays an address form, using the autocomplete feature
// of the Google Places API to help users fill in the information.

var placeSearch, autocomplete;
var componentForm = {
  street_number: 'short_name',
  route: 'long_name',
  locality: 'long_name',
  administrative_area_level_1: 'short_name',
  country: 'long_name',
  postal_code: 'short_name'
};

function initialize() {
  // Create the autocomplete object, restricting the search
  // to geographical location types.
  autocomplete = new google.maps.places.Autocomplete(
          /** @type {HTMLInputElement} */(document.getElementById('autocomplete')),
          {types: ['geocode']});
  // When the user selects an address from the dropdown,
  // populate the address fields in the form.
  google.maps.event.addListener(autocomplete, 'place_changed', function() {
    fillInAddress();
  });
}

function fillInAddress() {
  var place = autocomplete.getPlace();

  console.log('latitude: ' + place.geometry.location.lat());
  console.log('longitude: ' + place.geometry.location.lng());
  console.log('reference: ' + place.reference);

  //getPoint(place.geometry.location.lat(), place.geometry.location.lng(), place.reference);

}

function getPoint(lat, long, reference) {
  var map = new google.maps.Map(document.getElementById('map-canvas'), {
    center: new google.maps.LatLng(lat, long),
    zoom: 15
  });

  var request = {reference: reference};

  var infowindow = new google.maps.InfoWindow();
  var service = new google.maps.places.PlacesService(map);

  service.getDetails(request, function(place, status) {
    if (status == google.maps.places.PlacesServiceStatus.OK) {
      var marker = new google.maps.Marker({
        map: map,
        position: place.geometry.location
      });
      google.maps.event.addListener(marker, 'click', function() {
        infowindow.setContent(place.name);
        infowindow.open(map, this);
      });
    }
  });
}

function setPointsToMap() {

  var bounds = new google.maps.LatLngBounds();
  var colors = ['FE7569', '2134DD'];

  var longs = ['-8.410257300000012', '-7.915389000000005'];
  var lats = ['40.2033145', '40.66149'];
  var references = ['CoQBdAAAAIGfNKiczuJZ2XDf05emrlcMDnJJxi0kaPGFk2eYU-I4Cl9QnjXmp21oU7yG406OjSiOVT5uaWgi7vHFC35Aid4LaMOA0fTaKiSEWUbF3-pNLFwXan7tQuY4Wz-2H-5hOB7zS_hch8TamkGiCFR5ZL5FnKnf2nmwM1AdSmtYpXC_EhD0caQ5HLU5daeTowbHzOOcGhQPWqlL1tANef73dXQqypPX-KYg4g',
    'CnRmAAAAyxtqAu0qFNn_kbWum12C8veZIUDUIThV2iL8xnvC0B-fvrzPAqgIvLvZdRi_9W5Ysk8PWAtkh5gRyLFXBaDHa3P_EwEM24adsvSwsxXK3zqK5DluzJezLAaoHOKz75IHegLvYQFHTGUhP1dG9_5D0RIQGzdGJPEh9fy7f5qzXRZRFRoUleckCTddpaeWTU29E50yk2h9eTU'];
  
  for (var i = 0; i < 2; i++) {
    console.log('i: ' + i);

    var map = new google.maps.Map(document.getElementById('map-canvas'), {
      center: new google.maps.LatLng(lats[i], longs[i]),
      zoom: 15
    });

    var infowindow = new google.maps.InfoWindow();
    var service = new google.maps.places.PlacesService(map);
    
    console.log(references[i]);
    
    service.getDetails({reference: references[i], sensor: false, color: colors[i]}, function(place, status) {
      
      console.log('i: ' + i);
      console.log(place);
      console.log(status);
      
      
      if (status == google.maps.places.PlacesServiceStatus.OK) {
        var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + colors[0],
                new google.maps.Size(21, 34),
                new google.maps.Point(0, 0),
                new google.maps.Point(10, 34));
        var pinShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
                new google.maps.Size(40, 37),
                new google.maps.Point(0, 0),
                new google.maps.Point(12, 35));

        var marker = new google.maps.Marker({
          map: map,
          position: place.geometry.location,
          icon: pinImage,
          shadow: pinShadow
        });
        google.maps.event.addListener(marker, 'click', function() {
          infowindow.setContent(place.name);
          infowindow.open(map, this);
        });

      }
    });

    bounds.extend(new google.maps.LatLng(lats[i], longs[i]));
    
  }
  map.fitBounds(bounds);
}

function setPointsToMap_v2() {

  var bounds = new google.maps.LatLngBounds();

  var longs = ['-8.410257300000012', '-7.915389000000005'];
  var lats = ['40.2033145', '40.66149'];
  var references = ['CoQBdAAAAIGfNKiczuJZ2XDf05emrlcMDnJJxi0kaPGFk2eYU-I4Cl9QnjXmp21oU7yG406OjSiOVT5uaWgi7vHFC35Aid4LaMOA0fTaKiSEWUbF3-pNLFwXan7tQuY4Wz-2H-5hOB7zS_hch8TamkGiCFR5ZL5FnKnf2nmwM1AdSmtYpXC_EhD0caQ5HLU5daeTowbHzOOcGhQPWqlL1tANef73dXQqypPX-KYg4g',
    'CnRmAAAAyxtqAu0qFNn_kbWum12C8veZIUDUIThV2iL8xnvC0B-fvrzPAqgIvLvZdRi_9W5Ysk8PWAtkh5gRyLFXBaDHa3P_EwEM24adsvSwsxXK3zqK5DluzJezLAaoHOKz75IHegLvYQFHTGUhP1dG9_5D0RIQGzdGJPEh9fy7f5qzXRZRFRoUleckCTddpaeWTU29E50yk2h9eTU'];
  
  for (var i = 0; i < 2; i++) {
    var map = new google.maps.Map(document.getElementById('map-canvas'), {
      center: new google.maps.LatLng(lats[i], longs[i]),
      zoom: 15
    });

    var infowindow = new google.maps.InfoWindow();
    var service = new google.maps.places.PlacesService(map);
    
    service.getDetails({reference: references[i]}, function(place, status) {
      if (status == google.maps.places.PlacesServiceStatus.OK) {
        var marker = new google.maps.Marker({
          map: map,
          position: place.geometry.location
        });
        google.maps.event.addListener(marker, 'click', function() {
          infowindow.setContent(place.name);
          infowindow.open(map, this);
        });
      }
    });

    bounds.extend(new google.maps.LatLng(lats[i], longs[i]));
    
  }
  map.fitBounds(bounds);
}

// Bias the autocomplete object to the user's geographical location,
// as supplied by the browser's 'navigator.geolocation' object.
/*function geolocate() {
 if (navigator.geolocation) {
 navigator.geolocation.getCurrentPosition(function(position) {
 var geolocation = new google.maps.LatLng(
 position.coords.latitude, position.coords.longitude);
 autocomplete.setBounds(new google.maps.LatLngBounds(geolocation,
 geolocation));
 });
 }
 }*/