win = require("../mithril-giji.js")

describe "win.gesture", ->
  beforeEach ->

  it "tap OK", (done)->
    step = []
    g = new win.gesture
      debounce: 1
      timeout: 500
      disable: (bool)->
        if bool
          step.push "on"
        else
          step.push "off"
      do: (p)->
        p
        .then ({value, test})->
          step.push value
          step.push test

    console.warn g.tap({})

    setTimeout ->
      g.tap({}).onmouseup(test: "event 1")
    , 1
    setTimeout ->
      g.tap({}).ontouchend(test: "event 2")
    , 1
    setTimeout ->
      g.tap({}).onclick(test: "event 3")
    , 1
    setTimeout ->
      g.menu("tap 4", "now", {}).onmouseup(test: "event 4")
    , 5
    setTimeout ->
      g.menu("tap 5", "now", {}).ontouchend(test: "event 5")
    , 5
    setTimeout ->
      g.menu("tap 6", "now", {}).onclick(test: "event 6")
    , 5
    setTimeout ->
      expect( step.join(" ") ).to.eq "off on  event 1 off on tap 4 event 4 off"
      done()
    , 9


  it "tap timeout", (done)->
    step = []
    g = new win.gesture
      debounce: 10
      timeout: 10
      disable: (bool)->
        if bool
          step.push "on"
        else
          step.push "off"
      do: (p)->
        p
        .then ({test})->
          step.push test
          new Promise ->
        .then (e)->
          step.push "BAD"
    setTimeout ->
      g.tap({}).onmouseup(test: "tap 1")
      g.tap({}).ontouchend(test: "tap 2")
      g.tap({}).onclick(test: "tap 3")
    , 1
    setTimeout ->
      g.tap({}).onmouseup(test: "tap 4")
      g.tap({}).ontouchend(test: "tap 5")
      g.tap({}).onclick(test: "tap 6")
    , 2
    setTimeout ->
      expect( step.join(" ") ).to.eq "off on tap 1"
    , 5
    setTimeout ->
      g.tap({}).onmouseup(test: "tap 7")
      g.tap({}).ontouchend(test: "tap 8")
      g.tap({}).onclick(test: "tap 9")
    , 23
    setTimeout ->
      expect( step.join(" ") ).to.eq "off on tap 1 off on tap 7"
    , 32
    setTimeout ->
      expect( step.join(" ") ).to.eq "off on tap 1 off on tap 7 off"
      done()
    , 44

