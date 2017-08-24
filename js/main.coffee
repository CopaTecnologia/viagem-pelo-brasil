---
---

$ = (selector) -> document.querySelectorAll selector
_ = (nodes) -> Array.prototype.slice.call(nodes)

# Tabs navigation

introTabs = _ $ '#intro .tabs label'
introInputs = _ $ '#intro .toggle-input'
toggleTabs = ->
    tabId = introInputs.filter( (item) -> item.checked )[0].id
    for tab in introTabs
        if tab.getAttribute('for') is tabId
            tab.classList.add 'active'
        else
            tab.classList.remove 'active'
    tabId

toggleTabs()

introInputs.forEach (input) ->
    input.addEventListener 'change', -> toggleTabs()

# Map browser

mapBrowser.init

    createMapContainer: ->
        mapContainer    = document.createElement 'div'
        mapContainer.id = 'map-container'
        mapContainer.innerHTML =
            '''
            <div id="map-content"></div>
            <div class="map-overlay"></div>
            '''
        document.body.appendChild mapContainer
        mapContainer.querySelector('#map-content')

    mapMarkers: ->
        mapBrowserUI.articles.map (place) ->
            position:
                lat: Number place.getAttribute 'data-lat'
                lng: Number place.getAttribute 'data-lng'
            map: mapBrowser.map
            zIndex: 9
            icon: mapBrowserUI.icons.plane
            store_id: place.id

    ready: ->
        window.addEventListener 'load', (e) -> onHashChange(e)
        window.addEventListener 'hashchange', (e) -> onHashChange(e)

        onHashChange = ->
            mapBrowser.setMarker location.hash, mapBrowserUI.showArticle location.hash

        mapBrowserUI.init()