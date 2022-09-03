"""

    LocalLevel(level_scale::T) <: AbstractFloat

"""
function LocalLevel(level_scale::T) where T
    GaussianLinear(SA[1.;;], SA[0.], SA[1.;;], SA[convert(float(T), level_scale)^2;;])
end
