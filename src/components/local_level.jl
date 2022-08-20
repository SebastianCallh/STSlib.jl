"""

    LocalLevel(level_scale::T) <: AbstractFloat

"""
function LocalLevel(level_scale::T) where T
    GaussianLinear{float(T), 1, 1}([1.;;], [1.;;], diagm([convert(float(T), level_scale)^2]))
end
