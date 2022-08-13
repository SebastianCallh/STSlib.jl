struct Seasonal{T} <: Component{T}
    model::GaussianLinear{T}
    season_length::Int64
end

"""

Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::Real)

"""
function Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::T) where T <: AbstractFloat
    obs = Matrix(vcat(1, zeros(num_seasons-1))')
    trans = diagm(ones(num_seasons))[:,vcat(num_seasons, 1:num_seasons-1)]
    trans_cov = diagm(vcat(drift_scale^2, zeros(num_seasons-1)))
    Seasonal(GaussianLinear(T.(obs), T.(trans), T.(trans_cov)), season_length)
end

function Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::Integer)
    Seasonal(num_seasons, season_length, Float64(drift_scale))
end

latent_size(c::Seasonal) = latent_size(c.model)
num_params(c::Seasonal) = 0
Base.:(==)(c1::Seasonal, c2::Seasonal) = all([
    c1.model == c2.model,
    c1.season_length == c2.season_length
])

function (c::Seasonal{T})(x::Vector{T}, t::Integer) where T
   H, F, Q = c.model(x, t)
   num_seasons = size(F, 1)
   new_season = mod(t-1, c.season_length) == 0 && 1 < t   
   trans = new_season ? F : diagm(ones(T, num_seasons))
   trans_cov = new_season ? Q : diagm(zeros(T, num_seasons))
   H, trans, trans_cov
end
