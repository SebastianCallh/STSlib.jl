struct LocalLevel{T <: AbstractFloat} <: Component
    obs::Matrix{T}
    trans::Matrix{T}
    trans_cov::Matrix{T}
end

"""

    LocalLevel(level_scale::Real)

"""
function LocalLevel(level_scale::T = 1) where T <: AbstractFloat
    LocalLevel(T[1;;], T[1;;], diagm([level_scale^2]))
end

function LocalLevel(level_scale::Integer) 
    LocalLevel(Float64(level_scale))
end

latent_size(m::LocalLevel) = size(m.obs, 2)
observed_size(m::LocalLevel) = size(m.obs, 1)
Base.:(==)(c1::LocalLevel, c2::LocalLevel) = all([
    c1.obs == c2.obs,
    c1.trans == c2.trans,
    c1.trans_cov == c2.trans_cov,
])

function (m::LocalLevel)(t::Integer)
    m.obs, m.trans, m.trans_cov
end
