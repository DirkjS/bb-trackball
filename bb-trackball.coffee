# first try at johnny-five, node.js, firmata, coffeescript
# interfaces a blackberry trackball (sparkfun)
# trackball changes red en blue led, switches on and off the white led
#
# BLU - pin 10
# RED - pin 11
# GRE - pin 6
# WHT - pin 5
# UP  - pin 9
# DWN - pin 8
# LFT - pin 4
# RHT - pin 3


led_on = (led) ->
  led.on()

led_off = (led) ->
  led.off()
switch_led = (led, ledon) ->
  if ledon
    led.off()
    console.log "led uit?"
  else
    led.on()
    console.log "led aan?"
  ledon = !ledon

five = require("johnny-five")
board = new five.Board()

board.on "ready", ->
  # bv, bh hor and vert scrolling value
  bv = 0 
  bh = 0
  led_wht_on = false
  (new five.Led(13)).strobe 500
  (new five.Led(12)).strobe 600
  led_blu = new five.Led(10)
  led_red = new five.Led(11)
  led_wht = new five.Led(5)
  led_gre = new five.Led(6)
  pushbutton = new five.Button(
    pin: 2
    holdtime: 500
    invert: true
  )
  pushbutton.on "down", ->
    console.log "down"
    led_wht_on = switch_led(led_wht, led_wht_on)
  pushbutton.on "hold", ->
    console.log "hold"
  pushbutton.on "up", ->
    console.log "up"
    switch_led(led_wht, led_wht_on)
  bU = new five.Button(9)
  bD = new five.Button(8)
  bL = new five.Button(4)
  bR = new five.Button(3)
  bU.on "up", ->
    bv += 5
    if bv > 255
      bv = 0
    console.log "u " + bv
    led_red.fade(bv, 0)
  bD.on "up", ->
    bv -= 5
    if bv < 0
      bv = 255
    led_red.fade(bv, 0)
    console.log "d " + bv

  bL.on "up", ->
    bh += 5
    if bh > 255
      bh = 0
    console.log "l " + bh
    led_blu.fade(bh, 0)
  bR.on "up", ->
    bh -= 5
    if bh < 0
      bh = 255
    led_blu.fade(bh, 0)
    console.log "r " + bh


  # only to show off at start
  led_gre.fadeIn()
  @wait 1000, ->
    led_gre.fadeOut()
    #led_blu.fadeIn()
  @wait 2000, ->
    led_wht.fadeIn()
  @wait 3000, ->
    led_wht.fadeOut()
  @wait 5000, ->
    led_on(led_blu)
  @wait 6000, ->
    led_off(led_blu)
