---
---

mapBrowser = 
    icons:
        plane: '{{ site.baseurl }}/img/icons/airport.png'
        info: '{{ site.baseurl }}/img/icons/question.png'

    mapOptions:
        center:
            lat: -14.2400732
            lng: -53.1805017
        disableDefaultUI: true
        mapTypeId: google.maps.MapTypeId.TERRAIN
        zoom: 5

    init: (settings) ->
        @nav          = settings.mapNavContainer()
        @mapContainer = settings.createMapContainer()
        @mapContent   = settings.mapContent()
        @map          = new google.maps.Map(@mapContent, @mapOptions)
        @mapContent.style.height = '100%'
        @markers      = settings.mapMarkers().map (m) -> new google.maps.Marker m

    center: ->
        @map.panTo @mapOptions.center
        @map.setZoom @mapOptions.zoom
        @markers.forEach (marker) ->
                marker.setIcon @icons.plane
                marker.setAnimation null
            , @
    
    setMarker: (store_id) ->
        if store_id.indexOf '#' is 1
            store_id = store_id.substr(1)
        @markers.forEach (marker) ->
                if marker.store_id is store_id
                    @map.panTo marker.position
                    @map.setZoom @mapOptions.zoom + 2
                    marker.setIcon @icons.info
                    marker.setAnimation google.maps.Animation.BOUNCE
                else
                    marker.setIcon @icons.plane
                    marker.setAnimation null
            , @

    open: ->
        @mapContainer.classList.remove 'off'
        @nav.classList.remove 'off'

    close: ->
        @mapContainer.classList.add 'off'
        @nav.classList.add 'off'
    
    isOpen: ->
        @nav.classList.contains 'off'

window.mapBrowser = mapBrowser