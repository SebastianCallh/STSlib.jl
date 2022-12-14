module STSlib
using LinearAlgebra
using GaussianDistributions
using StaticArrays

export LocalLevel, LocalLinear, SemiLocalLinear, Seasonal, Sum, GaussianLinear
export latent_size, num_params, observation_matrix
export simulate
export transition, observe

include("components/utils.jl")
include("components/component.jl")
include("components/gaussian_linear.jl")
include("components/seasonal.jl")
include("components/local_level.jl")
include("components/local_linear.jl")
include("components/semi_local_linear.jl")
include("components/sum.jl")

end
