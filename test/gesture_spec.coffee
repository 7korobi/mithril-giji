win = require("../mithril-giji.js")

describe "win.gesture", ->
  beforeEach ->

  it "tap OK", (done)->
    step = []
    g = new win.gesture
      timeout: 500
      check: -> true
      disable: (bool)->
        if bool
          step.push "on"
        else
          step.push "off"
      do: (p)->
        p
        .then (e)->
          step.push e

    setTimeout ->
      g.tap({}).onmouseup("tap 1")
      g.tap({}).ontouchend("tap 2")
      g.tap({}).onclick("tap 3")
    , 1
    setTimeout ->
      g.tap({}).onmouseup("tap 4")
      g.tap({}).ontouchend("tap 5")
      g.tap({}).onclick("tap 6")
    , 2
    setTimeout ->
      expect( step.join(" ") ).to.eq "off on tap 1 off on tap 4 off"
      done()
    , 3


  it "tap timeout", (done)->
    step = []
    g = new win.gesture
      timeout: 10
      check: -> true
      disable: (bool)->
        if bool
          step.push "on"
        else
          step.push "off"
      do: (p)->
        p
        .then (e)->
          step.push e
          new Promise ->
        .then (e)->
          step.push "BAD"
    setTimeout ->
      g.tap({}).onmouseup("tap 1")
      g.tap({}).ontouchend("tap 2")
      g.tap({}).onclick("tap 3")
    , 1
    setTimeout ->
      g.tap({}).onmouseup("tap 4")
      g.tap({}).ontouchend("tap 5")
      g.tap({}).onclick("tap 6")
    , 2
    setTimeout ->
      expect( step.join(" ") ).to.eq "off on tap 1"
    , 5
    setTimeout ->
      g.tap({}).onmouseup("tap 7")
      g.tap({}).ontouchend("tap 8")
      g.tap({}).onclick("tap 9")
    , 15
    setTimeout ->
      expect( step.join(" ") ).to.eq "off on tap 1 off on tap 7"
    , 25
    setTimeout ->
      expect( step.join(" ") ).to.eq "off on tap 1 off on tap 7 off"
      done()
    , 35

