using Polynomials
using Plots
using JSON
using Roots

f = joinpath(@__DIR__,"./traces_relative.json")
s = read(f, String)
x = JSON.parse(s)
traces = x["GV12 Machining"]

results = Dict()
for (trace_id,values) in traces
  println(trace_id)
  xs = Float64[]
  ys = Float64[]
  results[trace_id] = Dict()
  for (x,y) in values
    push!(xs,parse(Float64,x))
    push!(ys,y)
  end
  println(extrema(xs))
  fitted = fit(xs, ys,8)
  println(fitted)
  println(derivative(fitted))
  println(derivative(derivative(fitted)))
  println(roots(derivative(derivative(fitted))))
  println(filter((x) -> isreal(x), roots(derivative(derivative(fitted)))))
  println(map((x) -> real(x), filter((x) -> isreal(x), roots(derivative(derivative(fitted))))))
  gr()
  sc = scatter(xs, ys, markerstrokewidth = 0, label = "Data")
   results[trace_id]["extremstellen"] = map((x) -> real(x), filter((x) -> isreal(x), roots(derivative(fitted))))
  results[trace_id]["extremstellen"] = filter(x -> (x>=0 && x<=maximum(x)), results[trace_id]["extremstellen"])
  results[trace_id]["wendestellen"] = map((x) -> real(x), filter((x) -> isreal(x), roots(derivative(derivative(fitted)))))
  results[trace_id]["wendestellen"] = filter(x -> (x>=0 && x<=maximum(x)), results[trace_id]["wendestellen"])

  trace_pois = vcat(map((x) -> real(x), results[trace_id]["extremstellen"]),map((x) -> real(x), results[trace_id]["wendestellen"]))
  
  savefig(joinpath(@__DIR__,"test_img/trace_images/$(replace(trace_id,":"=>"_"))_before.svg"))

  vline!(trace_pois, label = "potentially interesting timestamps", lc=:green)
  display(sc)

  savefig(joinpath(@__DIR__,"test_img/trace_images/$(replace(trace_id,":"=>"_")).svg"))
  println(results[trace_id])
end

open(joinpath(@__DIR__,"test_img/points_single_trace.json"),"w") do file
  JSON.print(file, results)
end

