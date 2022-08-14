"""

Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::Real)

"""
struct Seasonal{T} <: Component{T}
    H::Matrix{T}
    F::Matrix{T}
    Q::Matrix{T}
    F_noop::Matrix{T}
    Q_noop::Matrix{T}
    season_length::Int64
end

function Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::T) where T <: AbstractFloat
    H = Matrix(hcat(1, zeros(T, num_seasons-1)'))
    F = diagm(ones(T, num_seasons))[:,vcat(num_seasons, 1:num_seasons-1)]
    Q = diagm(vcat(drift_scale^2, zeros(T, num_seasons-1)))
    F_noop = diagm(ones(T, num_seasons))
    Q_noop = diagm(zeros(T, num_seasons))
    Seasonal(T.(H), T.(F), T.(Q), F_noop, Q_noop, season_length)
end

function Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::Integer)
    Seasonal(num_seasons, season_length, Float64(drift_scale))
end

latent_size(c::Seasonal) = size(c.H, 2)
num_params(c::Seasonal) = 0
Base.:(==)(c1::Seasonal, c2::Seasonal) = all([
    c1.H == c2.H,
    c1.F == c2.F,
    c1.Q == c2.Q,
    c2.F_noop == c2.F_noop,
    c1.Q_noop == c2.Q_noop,
    c1.season_length == c2.season_length
])

function _matrices(c::Seasonal{T}, t) where T    
    (; H, F, Q, F_noop, Q_noop, season_length) = c
    new_season = mod(t-1, season_length) == 0 && 1 < t  
    F = new_season ? F : F_noop
    Q = new_season ? Q : Q_noop
    return H, F, Q
end

function (c::Seasonal{T})(x::Vector{T}, t::Integer) where T
    H, F, _ = _matrices(c, t)
    x = F*x
    y = H*x
    return x, y
end

function (c::Seasonal{T})(x::Vector{T}, P::Matrix{T}, t::Integer) where T
    H, F, Q = _matrices(c, t)
    x = F*x
    P = F*P*F' + Q
    return x, P, H
end
