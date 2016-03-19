cb = ->

storage = (e)->
  { key, oldValue, newValue, url, storageArea } = e

touch = (e)->
  { touches, targetTouches, changedTouches } = e
  { shiftKey, ctrlKey, altKey, metaKey } = e
  { view, detail } = e
  { type, currentTarget, target, eventPhase, bubbles, cancelable, timeStamp } = e
  { preventDefault, stopImmediatePropagation, stopPropagation } = e

progress = (e)->
  { lengthComputable, loaded, total } = e
  { type, currentTarget, target, eventPhase, bubbles, cancelable, timeStamp } = e
  { preventDefault, stopImmediatePropagation, stopPropagation } = e

focus = (e)->
  { relatedTarget } = e
  { view, detail } = e
  { type, currentTarget, target, eventPhase, bubbles, cancelable, timeStamp } = e
  { preventDefault, stopImmediatePropagation, stopPropagation } = e

mouse = (e)->
  { clientX, clientY, momentX, momentY, buttons } = e
  { screenX, screenY, button, shiftKey, ctrlKey, altKey, metaKey, relatedTarget } = e
  { view, detail } = e
  { type, currentTarget, target, eventPhase, bubbles, cancelable, timeStamp } = e
  { preventDefault, stopImmediatePropagation, stopPropagation } = e

kbd = (e)->
  { keyCode, shiftKey, ctrlKey, altKey } = e
  { metaKey } = e
  { view, detail } = e
  { type, currentTarget, target, eventPhase, bubbles, cancelable, timeStamp } = e
  { preventDefault, stopImmediatePropagation, stopPropagation } = e

onload: cb
onunload: cb
onabort: cb
onerror: cb

onorientationchange: cb
onresize: cb
onmove: cb

onclick: cb
ondblclick: cb
onkeydown: kbd
onkeypress: kbd
onkeyup: kbd

onmousemove: mouse
onmouseover: mouse
onmouseout: mouse
onmousedown: mouse
onmouseup: mouse

ontouchstart: touch
ontouchmove: touch
ontouchend: touch
ontouchcancel: touch

ongesturestart: cb
ongestureend: cb
ongesturechange: cb

onfocus: focus
onblur: focus
onsubmit: cb
onreset: cb
onchange: cb
oninput:  cb

ondragdrop: cb
onselect: cb
