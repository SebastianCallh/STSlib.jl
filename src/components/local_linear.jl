"""

    LocalLinear(level_scale::T, slope_scale::T) where T <: AbstractFloat

"""
function LocalLinear(level_scale, slope_scale)
    GaussianLinear(SA[1. 0.], SA[0., 0.], SA[1. 1.; 0. 1.], SA[level_scale^2 0.; 0. slope_scale^2])
end