struct LocalLevel{T} <: Component{T}
    model::GaussianLinear{T}
end

"""

    LocalLevel(level_scale::Real)

"""
function LocalLevel(level_scale::T = 1.) where T <: AbstractFloat
    LocalLevel(GaussianLinear(T[1;;], T[1;;], diagm([level_scale^2])))
end

function LocalLevel(level_scale::Integer)
    LocalLevel(Float64(level_scale))
end

latent_size(c::LocalLevel) = latent_size(c.model)
num_params(c::LocalLevel) = 0
Base.:(==)(c1::LocalLevel, c2::LocalLevel) = c1.model == c2.model

@doc raw"""

    function (c::LocalLevel{T})(x::Vector{T}, args...) where T

Deterministic transition of state $x$.

"""
function (c::LocalLevel{T})(args...) where T
    return c.model(args...)
end

@doc raw"""

    function (c::LocalLevel{T})(x::Vector{T}, P::Matrix{T}, args...) where T

Probabilistic transition of state with mean $x$ and covariance matrix $P$.

"""
function (c::LocalLevel{T})(args...) where T
    return c.model(args...)
end