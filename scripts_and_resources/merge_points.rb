require 'json'
require 'typhoeus'

# ruby open.rb 104fe464-b780-4796-8c7d-9c05b400a259:ok

x = File.read(File.join(__dir__,"test_img/analysis/points.json"))
initial_obj = JSON.parse(x)
#obj = obj["difference_ok_nok_90-degrees-method"]
#obj = obj["difference_nok_ok_90-degrees-method"]
analysed_things = ["difference_ok_nok", "difference_ok_nok_90-degrees-method", "difference_ok_nok_shortest-distance-method", "difference_ok_nok_same-timestamp-method", "difference_nok_ok_90-degrees-method", "difference_nok_ok_shortest-distance-method", "difference_nok_ok_same-timestamp-method"]

y = File.read(File.join(__dir__,"test_img/points_single_trace.json"))
individual_trace_pois = JSON.parse(y)

analysed_things.each() do |analysed_thing|
  obj = initial_obj[analysed_thing]
  obj['traces'].each() do |k,v|
    obj['traces'][k] = individual_trace_pois[k]
  end
end
#puts initial_obj
File.write(File.join(__dir__,'test_img','analysis','full_points.json'), initial_obj.to_json())

