require 'spec_helper'
require_relative '../../support/file_test_helper'

RSpec.describe WS2801::Instance, file_write: false do
	let(  :default_instance) { WS2801::Instance.new                                        }
	let(:writeable_instance) { WS2801::Instance.new(length: 2, device: '/dev/test_device') }
	let(:buffer            ) { StringIO.new                                                }
	
	describe '.new' do
		it 'accepts parameters' do
			instance = WS2801::Instance.new(length: 10, strip: [1,2,3], device: 'test_asdf', autowrite: false)
			
			expect(instance.length   ).to eq 10
			expect(instance.strip    ).to eq [1,2,3]
			expect(instance.device   ).to eq 'test_asdf'
			expect(instance.autowrite).to eq false
		end
	end
	
	describe '#length' do
		it 'has a default value' do
			expect(default_instance.length).to eq 25
		end
		
		it 'can be set' do
			default_instance.length = 20
			
			expect(default_instance.length).to eq 20
		end
	end
	
	describe '#strip' do
		it 'has a default value' do
			expect(default_instance.strip).to eq []
		end
		
		it 'can be set' do
			default_instance.strip = [0,0,0]
			
			expect(default_instance.strip).to eq [0,0,0]
		end
	end
	
	describe '#device' do
		it 'has a default value' do
			expect(default_instance.device).to eq '/dev/spidev0.0'
		end
		
		it 'can be set' do
			default_instance.device = '/dev/spidev0.1'
			
			expect(default_instance.device).to eq '/dev/spidev0.1'
		end
	end
	
	describe '#autowrite' do
		it 'has a default value' do
			expect(default_instance.autowrite).to eq true
		end
		
		it 'can be set' do
			default_instance.autowrite = false
			
			expect(default_instance.autowrite).to eq false
		end
	end
	
	describe '#reset_strip' do
		it 'generates strip values' do
			default_instance.reset_strip
			
			expect(default_instance.strip.length).to eq 3*25
			expect(default_instance.strip       ).to all(be 0)
		end
	end
	
	describe '#resize_strip' do
		it 'generates strip values' do
			default_instance.resize_strip
			
			expect(default_instance.strip.length).to eq 3*25
			expect(default_instance.strip       ).to all(be 0)
		end
		
		it 'expands a strip' do
			default_instance.length = 2
			default_instance.strip  = [1,2,3]
			
			expect{default_instance.resize_strip}.    to change{default_instance.strip}.from([1,2,3]).to([1,2,3,0,0,0])
			expect{default_instance.resize_strip}.not_to change{default_instance.strip}
		end
		
		it 'shrinks a strip' do
			default_instance.length = 1
			default_instance.strip  = [1,2,3,4,5,6]
			
			expect{default_instance.resize_strip}.    to change{default_instance.strip}.from([1,2,3,4,5,6]).to([1,2,3])
			expect{default_instance.resize_strip}.not_to change{default_instance.strip}
		end
	end
	
	describe '#write', file_write: '/dev/test_device' do
		before do |example|
			writeable_instance.strip = [1,2,3,4,5,6]
		end
		
		it 'writes strip to the device' do
			expect(writeable_instance.write).to eq 7
			expect(buffer.string           ).to eq "\u0001\u0002\u0003\u0004\u0005\u0006\u0000"
		end
		
		context 'with parameter "only_if_autowrite"' do
			it 'does not write with only_if_autowrite set to true and autowrite set to false', file_write: false do
				writeable_instance.autowrite = false
				
				expect(writeable_instance.write(only_if_autowrite: true )).to eq false
				expect(buffer.string                                     ).to eq ''
			end
			
			it 'writes with only_if_autowrite set to true and autowrite set to true' do
				writeable_instance.autowrite = true
				
				expect(writeable_instance.write(only_if_autowrite: true )).to eq 7
				expect(buffer.string                                     ).to eq "\u0001\u0002\u0003\u0004\u0005\u0006\u0000"
			end
			
			it 'writes with only_if_autowrite set to false and autowrite set to false' do
				writeable_instance.autowrite = false
				
				expect(writeable_instance.write(only_if_autowrite: false)).to eq 7
				expect(buffer.string                                     ).to eq "\u0001\u0002\u0003\u0004\u0005\u0006\u0000"
			end
			
			it 'writes with only_if_autowrite set to false and autowrite set to true' do
				writeable_instance.autowrite = true
				
				expect(writeable_instance.write(only_if_autowrite: false)).to eq 7
				expect(buffer.string                                     ).to eq "\u0001\u0002\u0003\u0004\u0005\u0006\u0000"
			end
		end
	end
	
	describe '#set' do
		before do
			default_instance.length    = 4
			default_instance.autowrite = false
			
			default_instance.reset_strip
		end
		
		it 'sets a single pixel' do
			expect{default_instance.set(pixel: 1,       r: 5, g: 7, b: 2)}.to change{default_instance.strip}.from([0,0,0,0,0,0,0,0,0,0,0,0]).to([0,0,0,5,7,2,0,0,0,0,0,0])
		end
		
		it 'sets a range of pixels' do
			expect{default_instance.set(pixel: 1..3,    r: 5, g: 7, b: 2)}.to change{default_instance.strip}.from([0,0,0,0,0,0,0,0,0,0,0,0]).to([0,0,0,5,7,2,5,7,2,5,7,2])
		end
		
		it 'sets an array of pixels' do
			expect{default_instance.set(pixel: [1,2,3], r: 5, g: 7, b: 2)}.to change{default_instance.strip}.from([0,0,0,0,0,0,0,0,0,0,0,0]).to([0,0,0,5,7,2,5,7,2,5,7,2])
		end
		
		it 'has default values' do
			default_instance.strip = [1,2,3,4,5,6,7,8,9,1,2,3]
			
			expect{default_instance.set                                  }.to change{default_instance.strip}.from([1,2,3,4,5,6,7,8,9,1,2,3]).to([0,0,0,0,0,0,0,0,0,0,0,0])
		end
	end
	
	describe '#get' do
		it 'returns the RGB values of a single pixel in #strip' do
			default_instance.strip = [0,0,0,1,2,3,0,0,0]
			
			expect(default_instance.get(1)).to eq [1,2,3]
		end
	end
	
	describe '#off' do
		context 'with autowrite off', file_write: false do
			before do
				writeable_instance.autowrite = false
			end
			
			it 'sets all values in #strip to zeros and autowrites to device' do
				writeable_instance.length = 4
				writeable_instance.strip  = [1,2,3,4,5,6,7,8,9,1,2,3]
				
				expect{writeable_instance.off}.to change{writeable_instance.strip}.from([1,2,3,4,5,6,7,8,9,1,2,3]).to([0,0,0,0,0,0,0,0,0,0,0,0])
			end
		end
		
		context 'with autowrite on', file_write: '/dev/test_device' do
			it 'sets all values in #strip to zeros and autowrites to device' do
				writeable_instance.length = 4
				writeable_instance.strip  = [1,2,3,4,5,6,7,8,9,1,2,3]
				
				expect{writeable_instance.off}.to change{writeable_instance.strip}.from([1,2,3,4,5,6,7,8,9,1,2,3]).to([0,0,0,0,0,0,0,0,0,0,0,0])
				expect(buffer.string       ).to eq "\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000"
			end
		end
	end
end
