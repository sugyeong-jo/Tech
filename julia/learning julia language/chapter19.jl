#chapter 19
using Pkg
#Pkg.add("JSON")
Pkg.test("JSON")
using JSON
JSON.parse("""{
    "this": ["is", "json"],
    "numbers": [85, 16, 12.0],
    "and": [true, false, null]
    }""")


JSON.json(Dict(:a => :b, :c => [1, 2, 3.0], :d => nothing))
"{\"c\":[1.0,2.0,3.0],\"a\":\"b\",\"d\":null}"
println(ans)

mutable struct Point3D
    x::Float64
    y::Float64
    z::Float64
end

JSON.print(Point3D(1.0, 2.0, 3.0), 4)