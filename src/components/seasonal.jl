struct Seasonal{T <: AbstractFloat}  <: Component
    obs::Matrix{T}
    trans::Matrix{T}
    trans_cov::Matrix{T}
    season_length::Int64
end

"""

    Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::Real)

"""

function Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::T) where T <: AbstractFloat
    obs = Matrix(vcat(1, zeros(num_seasons-1))')
    trans = diagm(ones(num_seasons))[:,vcat(num_seasons, 1:num_seasons-1)]
    trans_cov = diagm(vcat(drift_scale^2, zeros(num_seasons-1)))
    Seasonal(T.(obs), T.(trans), T.(trans_cov), season_length)
end

function Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::Integer)
    Seasonal(num_seasons, season_length, Float64(drift_scale))
end

latent_size(m::Seasonal) = size(m.obs, 2)
Base.:(==)(c1::Seasonal, c2::Seasonal) = all([
    c1.obs == c2.obs,
    c1.trans == c2.trans,
    c1.trans_cov == c2.trans_cov,
    c1.season_length == c2.season_length
])


function (m::Seasonal)(t::Integer)
   num_seasons = size(m.trans, 1)
   new_season = mod(t-1, m.season_length) == 0 && 1 < t   
   trans = new_season ? m.trans : diagm(ones(eltype(m.trans), num_seasons))
   trans_cov = new_season ? m.trans_cov : diagm(zeros(eltype(m.trans_cov), num_seasons))
   m.obs, trans, trans_cov
end
