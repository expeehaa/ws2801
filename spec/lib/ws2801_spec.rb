require 'spec_helper'

RSpec.describe WS2801 do
	describe '.instance' do
		it 'returns an instance' do
			instance = WS2801.instance
			
			expect(instance       ).to be_a WS2801::Instance
			expect(WS2801.instance).to be   instance
		end
	end
end