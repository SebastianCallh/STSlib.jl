struct LocalLevel{T} <: GaussianLinear{T}
    H::Matrix{T}
    F::Matrix{T}
    Q::Matrix{T}
end

"""

    LocalLevel(level_scale::T) <: AbstractFloat

"""
function LocalLevel(level_scale::T) where T
    LocalLevel([1.;;], [1.;;], diagm([convert(float(T), level_scale)^2]))
end

transition(c::LocalLevel{T}, x, t::Integer) where T = transition(c, x)
transition(c::LocalLevel{T}, x, P, t::Integer) where T = transition(c, x, P)
