require 'spec_helper'
require_relative '../support/spi_test_helper'

RSpec.describe WS2801, mock_spi: true do
	describe '.instance' do
		it 'returns an instance' do
			instance = WS2801.instance
			
			expect(instance       ).to be_a WS2801::Instance
			expect(WS2801.instance).to be   instance
		end
	end
end