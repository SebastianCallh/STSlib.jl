struct LocalLevel <: Component
    obs::Matrix{Int64}
    trans::Matrix{Int64}
    trans_cov::Matrix{Float64}
end

"""

    LocalLevel(level_scale::Real)

"""
LocalLevel(level_scale=1.) = LocalLevel([1;;], [1;;], diagm([level_scale^2]))
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
