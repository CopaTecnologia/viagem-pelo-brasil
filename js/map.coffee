---
---

icon = 
    plane: '{{ site.baseurl }}/img/icons/airport.png'
    info: '{{ site.baseurl }}/img/icons/question.png'

mapOptions = 
    center:
        lat: -14.2400732
        lng: -53.1805017
    disableDefaultUI: true
    mapTypeId: google.maps.MapTypeId.TERRAIN
    zoom: 5

mapContainer = document.querySelector '.site-header'
if mapContent = document.getElementById 'mapa'

    map = new google.maps.Map(mapContent, mapOptions)
    infoMarker = new google.maps.Marker()
    infoWindows = document.querySelectorAll '#places [data-lat][data-lng]'
    markers = Array.prototype.map.call infoWindows, (place) ->
        new google.maps.Marker(
            position:
                lat: Number place.getAttribute 'data-lat'
                lng: Number place.getAttribute 'data-lng'
            map: map
            zIndex: 9
            icon: icon.plane
        )

    window.addEventListener 'load', -> setMarkers()
    window.addEventListener 'hashchange', -> setMarkers()

    setMarkers = ->

        if (place = document.querySelector location.hash) and (place.getAttribute 'data-lat') and (place.getAttribute 'data-lng')

            console.log place

        else

            map.panTo mapOptions.center
            map.setZoom mapOptions.zoom
            infoMarker.setIcon icon.plane
            infoMarker.setAnimation null
