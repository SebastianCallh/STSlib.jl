module STSlib
using LinearAlgebra

export Seasonal, LocalLinear

include("models/local_linear.jl")
include("models/seasonal.jl")

end
