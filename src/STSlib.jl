module STSlib
using LinearAlgebra
using GaussianDistributions

export LocalLevel, LocalLinear, Seasonal, Sum, Autoregressive, GaussianLinear
export latent_size, num_params
export simulate

include("components/utils.jl")
include("components/component.jl")
include("components/gaussian_linear.jl")
include("components/local_level.jl")
include("components/local_linear.jl")
include("components/seasonal.jl")
include("components/autoregressive.jl")
include("components/sum.jl")

end
