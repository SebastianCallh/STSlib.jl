struct LocalLinear{T} <: Component{T}
    model::GaussianLinear{T}
end

"""

    LocalLinear(level_scale::Real, slope_scale::Real)

"""
function LocalLinear(level_scale::T = 1., slope_scale::T = 1.) where T <: AbstractFloat
    LocalLinear(GaussianLinear(T[1 0], T[1 1; 0 1], diagm([level_scale^2, slope_scale^2])))
end

function LocalLinear(level_scale::Integer = 1, slope_scale::Integer = 1)
    LocalLinear(Float64(level_scale), Float64(slope_scale))
end

latent_size(c::LocalLinear) = latent_size(c.model)
num_params(c::LocalLinear) = 0
Base.:(==)(c1::LocalLinear, c2::LocalLinear) = c1.model == c2.model

function (c::LocalLinear{T})(x::Vector{T}, t::Integer) where T
    return c.model(x, t)
end
