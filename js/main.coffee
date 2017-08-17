---
---

$ = (selector) -> document.querySelectorAll selector
_ = (nodes) -> Array.prototype.slice.call(nodes)

menuLink = $('.menu-link')[0]
menuLinkText = menuLink.textContent
menuLink.addEventListener 'click', (e) ->
    e.preventDefault()
    siteNav = $('.site-nav')[0]
    if siteNav.classList.contains('open')
        siteNav.classList.remove 'open'
        menuLink.textContent = menuLinkText
    else
        siteNav.classList.add 'open'
        menuLink.textContent = '⨉'

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