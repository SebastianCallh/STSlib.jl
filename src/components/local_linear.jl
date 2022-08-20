"""

    LocalLinear(level_scale::T, slope_scale::T) where T <: AbstractFloat

"""
function LocalLinear(level_scale::T, slope_scale::U) where {T, U}
    GaussianLinear{float(T), 1, 2}([1. 0.], [1. 1.; 0. 1.], diagm([convert(float(T), level_scale)^2, convert(float(U), slope_scale)^2]))
end