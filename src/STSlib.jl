module STSlib
using LinearAlgebra
using GaussianDistributions

export LocalLevel, LocalLinear, Seasonal, Sum 
export latent_size, observed_size
export simulate

include("components/utils.jl")
include("components/component.jl")
include("components/seasonal.jl")
include("components/local_level.jl")
include("components/local_linear.jl")
include("components/sum.jl")

end
