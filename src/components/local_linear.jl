struct LocalLinear{T <: AbstractFloat} <: Component
    obs::Matrix{T}
    trans::Matrix{T}
    trans_cov::Matrix{T}
end

"""

    LocalLinear(level_scale::Real, slope_scale::Real)

"""
function LocalLinear(level_scale::T = 1., slope_scale::T = 1.) where T <: AbstractFloat
    LocalLinear(T[1 0], T[1 1; 0 1], diagm([level_scale^2, slope_scale^2]))
end

function LocalLinear(level_scale::Integer = 1, slope_scale::Integer = 1) 
    LocalLinear(Float64(level_scale), Float64(slope_scale))
end

latent_size(m::LocalLinear) = size(m.obs, 2)
Base.:(==)(c1::LocalLinear, c2::LocalLinear) = all([
    c1.obs == c2.obs,
    c1.trans == c2.trans,
    c1.trans_cov == c2.trans_cov,
])

function (m::LocalLinear)(t::Integer)
    m.obs, m.trans, m.trans_cov
end
