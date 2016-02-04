{expect} = require('chai')
win = require("../mithril-giji.js")

describe "mount", ()->
  it "mount", ->
    win.on.load = []
    win.mount "#test", (dom)->

describe "layout", ()->
  it "floating", ->
    win.on.load = []
    win.mount "#test", (dom)->
      layout = new win.layout dom, 10, 11
      win.do.layout()
      expect( layout.dx ).to.eq 10
      expect( layout.dy ).to.eq 11
      expect( layout.box.style.left ).to.eq 0
      expect( layout.box.style.top ).to.eq  0
      expect( layout.box.style.zIndex ).to.eq 1001
      expect( layout.box.style.position ).to.eq "fixed"
      expect( layout.box.style.transform ).to.eq "translate(10px, 11px)"
    win.do.load()
