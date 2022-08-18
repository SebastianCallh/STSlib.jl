struct LocalLinear{T} <: GaussianLinear{T}
    H::Matrix{T}
    F::Matrix{T}
    Q::Matrix{T}
end

"""

    LocalLinear(level_scale::T, slope_scale::T) where T <: AbstractFloat

"""
function LocalLinear(level_scale::T, slope_scale::U) where {T, U}
    LocalLinear([1. 0.], [1. 1.; 0. 1.], diagm([convert(float(T), level_scale)^2, convert(float(U), slope_scale)^2]))
end

transition(c::LocalLinear{T}, x::Vector{T}, t::Integer) where T = transition(c, x)
transition(c::LocalLinear{T}, x::Vector{T}, P::Matrix{T}, t::Integer) where T = transition(c, x, P)