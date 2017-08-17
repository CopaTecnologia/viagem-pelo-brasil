(function($, window, google) {

	var icon = "Icons/airport.png",
	zoom = 5,
	center = { // Brasil: -14.2400732,-53.1805017
			lat: -14.2400732,
			lng: -53.1805017
		},
	options = {
		center: center,
		disableDefaultUI: true,
		mapTypeId: google.maps.MapTypeId.TERRAIN,
		zoom: zoom
	},
	element = document.getElementById('map-div'),
	map = !!element ? new google.maps.Map(element, options) : undefined,
	infoMarker = new google.maps.Marker(),
	infoIcon = "Icons/symbol_inter.png",
	markers = [];

	$('.info-windows [data-indice][data-lat][data-lng]').each(function(index) {
		var el = $(this),
		pos = {
			lat: Number(el.attr('data-lat')),
			lng: Number(el.attr('data-lng'))
		},
		marker = new google.maps.Marker({
			position: pos,
			map: map,
			zIndex: 9,
			icon: icon
		});
		markers[el.attr('data-cod')] = marker;
	});



	$(window).on('load hashchange', function(event) {
		var $local = $(location.hash);
		infoMarker.setIcon(icon);
		infoMarker.setAnimation(null);
		if ($local.attr('data-lat') && $local.attr('data-lng')) {
			var place = {
					lat: Number($local.attr('data-lat')),
					lng: Number($local.attr('data-lng'))
			};
			map.panTo(place);
			map.setZoom(zoom + 2);
			infoMarker = markers[$local.attr('data-cod')];
			infoMarker.setIcon(infoIcon);
			infoMarker.setAnimation(google.maps.Animation.BOUNCE);
		}
		else if(map){
			map.panTo(center);
			map.setZoom(zoom);
		}
	});

}(jQuery, window, google));