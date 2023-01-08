"""

    LocalLevel(level_scale::T) <: AbstractFloat

"""
function LocalLevel(level_scale) where T
    GaussianLinear(SA[1.;;], SA[0.], SA[1.;;], SA[float(level_scale)^2;;])
end
