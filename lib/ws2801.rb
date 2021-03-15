#
# Controller for: RGB Pixel with WS2801 Chip
# build for Diffused Digital RGB LED Pixels from Adafruits on Raspberry Pi
# but should work on any device and the same led chip
# (c) 2013 Roman Pramberger (roman@pramberger.ch)
#
# WS2801 user-space driver

require_relative 'ws2801/instance'

module WS2801
	def self.instance
		@instance ||= WS2801::Instance.new
	end
	
	def self.method_missing(method, *args, &block)
		if instance.respond_to?(method)
			instance.send(method, *args, &block)
		else
			super
		end
	end
	
	def self.respond_to_missing?(method_name, include_private = false)
		instance.respond_to?(method_name) || super
	end
end
