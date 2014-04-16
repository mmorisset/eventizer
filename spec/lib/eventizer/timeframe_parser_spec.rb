# # encoding: utf-8
# require 'spec_helper'

# describe TimeframeParser do
#   let(:timeframe_parser) { TimeframeParser.new }

#   before do
#   end

#   describe 'parse' do
#     it 'doesn\'t parse nil timeframe' do
#       timeframe_parser.parse(nil).should eq(nil)
#     end

#     it 'doesn\'t parse wrong timeframe' do
#       timeframe_parser.parse('wrong_timeframe').should eq(nil)
#     end

#     it 'parses timeframe' do
#       timeframe_parser.parse(nil).should eq(nil)
#       timeframe_parser.parse('this_month').should eq(
#         Jbuilder.encode do |json|
#           json.start_time Time.now - 1.months
#           json.end_time Time.now
#         end
#       )
#       timeframe_parser.parse('previous_month').should eq(
#         Jbuilder.encode do |json|
#           json.start_time Time.now.beginning_of_month - 1.months
#           json.end_time Time.now.beginning_of_month
#         end
#       )
#       timeframe_parser.parse('this_3_months').should eq(
#         Jbuilder.encode do |json|
#           json.start_time Time.now - 3.months
#           json.end_time Time.now
#         end
#       )
#       timeframe_parser.parse('previous_3_months').should eq(
#         Jbuilder.encode do |json|
#           json.start_time Time.now.beginning_of_month - 3.months
#           json.end_time Time.now.beginning_of_month
#         end
#       )
#     end
#   end
# end
