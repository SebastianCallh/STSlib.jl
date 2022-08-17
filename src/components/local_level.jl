struct LocalLevel{T} <: GaussianLinear{T}
    H::Matrix{T}
    F::Matrix{T}
    Q::Matrix{T}
end

"""

    LocalLevel(level_scale::Real)

"""
function LocalLevel(level_scale::T = 1.) where T <: AbstractFloat
    LocalLevel(T[1;;], T[1;;], diagm([level_scale^2]))
end

function LocalLevel(level_scale::Integer)
    LocalLevel(Float64(level_scale))
end

transition(c::LocalLevel{T}, x::Vector{T}, t::Integer) where T = transition(c, x)
transition(c::LocalLevel{T}, x::Vector{T}, P::Matrix{T}, t::Integer) where T = transition(c, x, P)
