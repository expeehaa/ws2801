ws2801 gem
======

Controlling LED Stripes/Pixel with ws2801 chips from Ruby on Raspberry PI or similar

---

## Reference
*   Used Pixels
[12mm Diffused Digital RGB LED Pixels](http://www.play-zone.ch/de/12mm-diffused-digital-rgb-led-pixels-25er-strang-ws2801.html) (other products, with same chipset should work fine too)
*   Connected after [the Adafruit Guide](http://learn.adafruit.com/light-painting-with-raspberry-pi/hardware)
*   Developed in **Ruby 2.7.2** (should work with at least 2.5+)
*   Links for this Gem: [Rubygems](https://rubygems.org/gems/ws2801), [Rubydoc](http://rubydoc.info/github/b1nary/ws2801/master/WS2801), [Github](https://github.com/b1nary/ws2801)

----

## Installation

Install directly from Rubygems

    gem install ws2801

---

## Basic Usage

Set all to green

    WS2801.set g: 255

Set first pixel to blue

    WS2801.set pixel: 0, b: 255

Set off

    WS2801.off

Set first half to bright white

    WS2801.set pixel: (0..(WS2801.length/2)).to_a, r: 255, g: 255, b: 255

Change length (default: 32)

    WS2801.length = 50

Internally, the method calls on `WS2801` in the above examples are delegated to an instance of `WS2801::Instance`.
If you need more control over the pixels or happen to have multiple devices, you can create new instances of the `WS2801::Instance` class to work with the LEDs.

    instance = WS2801::Instance.new(length: 32, device: '/dev/spidev0.1', autowrite: false)
    
    instance.set g: 255

[**Full Documentation**](http://rubydoc.info/github/b1nary/ws2801/master/WS2801)

## Effects

In addition to simply setting pixels, the library also provides methods for some effects/procedures.
They can be called like any other method.

Effects are currently untested and may not work.


Fade some pixel to red

    WS2801.fade pixel: [1,4,7,12,18], r: 255

---

# Changelog

* 1.1.0 Include WS2801::Effects, fix fading
* 1.0.2 Include fading
* 1.0 Calling Stable
* 0.2 Refactoring
* 0.1.2 Release
