---
---

_turnOn = (elements) ->
    elements.forEach (elem) ->
        elem.classList.add 'on'
        elem.classList.remove 'off'

_turnOff = (elements) ->
    elements.forEach (elem) ->
        elem.classList.add 'off'
        elem.classList.remove 'on'

_viewport = ->
    orientation = screen.orientation or screen.mozOrientation or screen.msOrientation
    angle = orientation.angle or 0
    pixelRatio = navigator.userAgent.indexOf 'Android' >= 0 and window.devicePixelRatio
    width: ->
        vw = if angle is 0 then window.screen.width else window.screen.height
        if devicePixelRatio
            vw = vw / window.devicePixelRatio
        vw
    height: ->
        vh = if angle is 0 then window.screen.height else window.screen.width
        if devicePixelRatio
            vh = vh / window.devicePixelRatio
        vh

_zoom = if _viewport().width() > 600 and _viewport().height() > 600 then 5 else 3

window.mapBrowser = 

    init: (settings) ->
        @mapContainer = settings.createMapContainer()
        @map          = new google.maps.Map(@mapContainer, mapBrowserUI.mapOptions)
        @mapContainer.style.height = '100%'
        @markers      = settings.mapMarkers().map (m) -> new google.maps.Marker m
        settings.ready()

    center: ->
        @map.panTo mapBrowserUI.mapOptions.center
        @map.setZoom mapBrowserUI.mapOptions.zoom
    
    setMarker: (store_id, fn) ->
        _markerFound = false
        if store_id.indexOf '#' is 1
            store_id = store_id.substr(1)
        @markers.forEach (marker) ->
                if marker.store_id is store_id
                    _markerFound = true
                    @map.panTo marker.position
                    @map.setZoom mapBrowserUI.mapOptions.zoom + 2
                    marker.setIcon mapBrowserUI.icons.info
                    marker.setAnimation google.maps.Animation.BOUNCE
                else
                    marker.setIcon mapBrowserUI.icons.plane
                    marker.setAnimation null
            , @
        if not _markerFound
            @center()
        fn() if typeof fn? is 'function'

window.mapBrowserUI = 

    icons:
        plane: '{{ site.baseurl }}/img/icons/airport.png'
        info: '{{ site.baseurl }}/img/icons/question.png'

    mapOptions:
        center:
            lat: -14.2400732
            lng: -53.1805017
        disableDefaultUI: true
        mapTypeId: google.maps.MapTypeId.TERRAIN
        zoom: _zoom

    articles: Array.prototype.slice.call( document.querySelectorAll '#places [data-lat][data-lng]' )

    showArticle: (hash) ->
        _turnOff @articles
        return if hash is '' or hash is '#'
        _turnOn [ document.querySelector hash ]

    openMenu: ->
        _turnOn [ mapBrowser.mapContainer.parentNode, @mapNav ]
        @menuLink.textContent = '⨉'
        @showArticle location.hash

    closeMenu: ->
        _turnOff [ mapBrowser.mapContainer.parentNode, @mapNav ]
        @menuLink.textContent = @menuLinkText
        _turnOff @articles

    init: ->
        @mapNav = document.querySelector '.places-menu'
        @menuLink = @mapNav.querySelector '#btn-open-places'
        @menuLinkText = @menuLink.textContent
        @mapNav.classList.remove 'no-js'
        _turnOff @articles
        _this = @

        if not location.hash
            @closeMenu()
        else
            @menuLink.textContent = '⨉'
        

        @menuLink.addEventListener 'click', (e) ->
            e.preventDefault()
            if _this.mapNav.classList.contains 'off'
                _this.openMenu()
            else
                _this.closeMenu()
