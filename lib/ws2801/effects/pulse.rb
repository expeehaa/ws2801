module WS2801
	module Effects
		module Pulse
			# Pulse Effect
			# 
			# Example:
			#   >> WS2801E.pulse({ direction: :outer, r: 255 })
			#   >> WS2801E.pulse({ b: 255, g: 255 })
			# 
			# Arguments (or nil):
			#   pixel: (Number-Array|Integer|:all) [default: :all]
			#   r: (Integer) 0-255 red [default: 0]
			#   g: (Integer) 0-255 green [default: 0]
			#   b: (Integer) 0-255 blue [default: 0]
			#   direction: (Symbol) :start | :end | :inner | :outer [default: :start]
			#   timeout: (Float) [default: 0.1]
			#   keep: (Boolean) if pixels get blacked out [default: true]
			def pulse options = {}
				options[:pixel] = (0..(self.length-1)).to_a if options[:pixel].nil? or options[:pixel] == :all
				options[:pixel] = [options[:pixel]] if options[:pixel].is_a? Numeric
				options[:r] = 0 if options[:r].nil?
				options[:g] = 0 if options[:g].nil?
				options[:b] = 0 if options[:b].nil?
				options[:direction] = :start if options[:direction].nil?
				options[:timeout] = 0.1 if options[:timeout].to_f == 0.0
				options[:keep] = true if options[:keep].nil?
				
				self.reset_strip if !options[:keep]
				if options[:direction] == :start
					self.length.times do |i|
						self.reset_strip if !options[:keep]
						self.set({ r: options[:r], g: options[:g], b: options[:b], pixel: i })
						sleep(options[:timeout])
					end
				elsif options[:direction] == :end
					self.length.times do |i|
						self.reset_strip if !options[:keep]
						self.set({ r: options[:r], g: options[:g], b: options[:b], pixel: self.length-i })
						sleep(options[:timeout])
					end
				elsif options[:direction] == :inner
					first = self.length/2.0
					if first % 1 != 0
						first = first.to_i + 1
					end
					self.reset_strip if !options[:keep]
					((self.length/2)+1).times do |i|
						self.reset_strip if !options[:keep]
						self.set({ pixel: [first-i, first+i], r: options[:r], g: options[:g], b: options[:b] })
						sleep(options[:timeout])
					end
				elsif options[:direction] == :outer
					self.reset_strip if !options[:keep]
					((self.length/2)+1).times do |i|
						self.reset_strip if !options[:keep]
						self.set({ pixel: [0+i, self.length-i], r: options[:r], g: options[:g], b: options[:b] })
						sleep(options[:timeout])
					end
				end
			end
		end
	end
end