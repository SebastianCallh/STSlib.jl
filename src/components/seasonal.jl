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

function Seasonal(num_seasons::T, season_length::U, drift_scale::V) where {T, U, V}
    H = Matrix(hcat(1, zeros(T, num_seasons-1)'))
    F = diagm(ones(T, num_seasons))[:,vcat(num_seasons, 1:num_seasons-1)]
    Q = diagm(vcat(convert(float(V), drift_scale)^2, zeros(T, num_seasons-1)))
    F_noop = diagm(ones(T, num_seasons))
    Q_noop = diagm(zeros(T, num_seasons))

    to_float(type, x) = convert.(float(type), x)
    Seasonal(to_float(T, H), to_float(T, F), to_float(T, Q), to_float(T, F_noop), to_float(T, Q_noop), season_length)
end

observation_matrix(c::Seasonal) = c.H
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

function _transition_mats(c::Seasonal{T}, t) where T
    (; F, Q, F_noop, Q_noop, season_length) = c
    new_season = mod(t-1, season_length) == 0 && 1 < t  
    F = new_season ? F : F_noop
    Q = new_season ? Q : Q_noop
    return F, Q
end


@doc raw"""

    function observe(c::Seasonal{T}, x::Vector{T}) where T

Deterministic observation of state $x$.

"""
function observe(c::Seasonal{T}, x::Vector{T}) where T
    (;H) = c
    return H*x
end

@doc raw"""

    function observe(c::Seasonal{T}, x::Vector{T}, P::Matrix{T}, R::Matrix{T}) where T

Probabilistic observation of state with mean $x$, covariance $P$ and observation noise covariance $R$.

"""
function observe(c::Seasonal{T}, x::Vector{T}, P::Matrix{T}, R::Matrix{T}) where T
    (;H) = c
    y = H*x
    S = H*P*H' + R
    return y, S
end

@doc raw"""

    function transition(c::Seasonal{T}, x::Vector{T}, t::Integer) where T

Deterministic transition of state $x$ for time step $t$.

"""
function transition(c::Seasonal{T}, x::Vector{T}, t::Integer) where T
    F, _ = _transition_mats(c, t)
    return F*x
end

@doc raw"""

    function transition(c::Seasonal{T}, x::Vector{T}, P::Matrix{T}, t::Integer) where T

Probabilistic transition of state with mean $x$ and covariance $P$ for time step $t$.

"""
function transition(c::Seasonal{T}, x::Vector{T}, P::Matrix{T}, t::Integer) where T
    F, Q = _transition_mats(c, t)
    x = F*x
    P = F*P*F' + Q
    return x, P
end
