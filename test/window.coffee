{expect} = require('chai')
win = require("../mithril-giji.js")

describe "window property", ()->
  it "browser", ->
    win.do.scroll {}
    expect( win.height ).to.eq 100
    expect( win.width  ).to.eq  90
    expect( win.short ).to.eq   90

    expect( win.top ).to.eq     20
    expect( win.horizon ).to.eq 50
    expect( win.bottom ).to.eq 120
    expect( win.left ).to.eq    10
    expect( win.right ).to.eq  110

  it "follows", ->
    expect( win.is_tap ).to.eq false
