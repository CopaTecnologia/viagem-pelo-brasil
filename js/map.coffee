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

mapContainer = document.getElementById 'map-container'
if mapContent = document.getElementById 'map-content'

    map = new google.maps.Map(mapContent, mapOptions)
    mapContent.style.height = '100%'
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

        if location.hash and (place = document.querySelector location.hash) and (lat = place.getAttribute 'data-lat') and (lng = place.getAttribute 'data-lng')

            map.panTo(
                lat: Number lat
                lng: Number lng
            )
            map.setZoom mapOptions.zoom + 2

        else

            map.panTo mapOptions.center
            map.setZoom mapOptions.zoom
            infoMarker.setIcon icon.plane
            infoMarker.setAnimation null



menuLink = document.getElementById 'btn-open-places'
menuLinkText = menuLink.textContent
menuLink.addEventListener 'click', (e) ->
    e.preventDefault()
    siteNav = document.querySelector('.site-nav')
    if siteNav.classList.contains('open')
        location.hash = ''
        mapContainer.classList.remove 'open'
        siteNav.classList.remove 'open'
        menuLink.textContent = menuLinkText
    else
        mapContainer.classList.add 'open'
        siteNav.classList.add 'open'
        menuLink.textContent = '⨉'
