---
---

$ = (selector) -> document.querySelectorAll selector
_ = (nodes) -> Array.prototype.slice.call(nodes)
$el = (tag, attrs) -> 
    elem = document.createElement tag
    return elem unless attrs?
    for attr, val of attrs
        elem[attr] = val
    elem
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


mapBrowser.init
    mapNavContainer: ->
        mapNav = $( '.places-menu' )[0]
        mapNav.classList.remove 'no-js'
        mapNav
    createMapContainer: ->
        mapContainer = $el 'div', 
            id: 'map-container'
            innerHTML: 
                '''
                <div id="map-content"></div>
                <div class="map-overlay"></div>
                '''
        document.body.appendChild mapContainer
        mapContainer
    mapContent: ->
        $('#map-container')[0].querySelector('#map-content')
    mapMarkers: ->
        infoWindows = $ '#places [data-lat][data-lng]'
        Array.prototype.map.call infoWindows, (place) ->
            position:
                lat: Number place.getAttribute 'data-lat'
                lng: Number place.getAttribute 'data-lng'
            map: mapBrowser.map
            zIndex: 9
            icon: mapBrowser.icons.plane
            store_id: place.id

window.addEventListener 'load', (e) -> onHashChange(e)
window.addEventListener 'hashchange', (e) -> onHashChange(e)

onHashChange = ->
    if location.hash and (place = document.querySelector location.hash)
        mapBrowser.setMarker location.hash
    else
        mapBrowser.center()

menuLink = mapBrowser.nav.querySelector '#btn-open-places'
menuLinkText = menuLink.textContent

closeMenu = ->
    mapBrowser.close()
    menuLink.textContent = menuLinkText

openMenu = ->
    mapBrowser.open()
    menuLink.textContent = '⨉'

if not location.hash
    closeMenu()
else
    menuLink.textContent = '⨉'

menuLink.addEventListener 'click', (e) ->
    e.preventDefault()
    if mapBrowser.isOpen()
        openMenu()
    else
        closeMenu()
