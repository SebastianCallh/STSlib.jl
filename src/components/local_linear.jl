"""

    LocalLinear(level_scale::T, slope_scale::T) where T <: AbstractFloat

"""
function LocalLinear(level_scale::T, slope_scale::U) where {T, U}
    GaussianLinear(SA[1. 0.], SA[1. 1.; 0. 1.], SA[convert(float(T), level_scale)^2 0; 0 convert(float(U), slope_scale)^2])
end