"""

Seasonal(num_seasons::Integer, season_length::Integer, drift_scale::Real)

"""
struct Seasonal{T, U <: AbstractMatrix{T}, V <: AbstractMatrix{T}} <: AbstractComponent{T}
    H::U
    F::V
    Q::V
    F_noop::V
    Q_noop::V
    season_length::Int64
end

function Seasonal(num_seasons::T, season_length::U, drift_scale::V) where {T, U, V}
    H = SMatrix{1, num_seasons, V}(vcat(1, zeros(num_seasons-1)))
    F = diagm(ones(T, num_seasons))[:,vcat(num_seasons, 1:num_seasons-1)]
    F = SMatrix{size(F)..., eltype(F)}(F)
    Q =  diagm(vcat(convert(float(V), drift_scale)^2, @SVector zeros(T, num_seasons-1)))
    F_noop = diagm(@SVector ones(T, num_seasons))
    Q_noop = diagm(@SVector zeros(T, num_seasons))

    to_float(x) = convert.(float(V), x)
    Seasonal(to_float(H), to_float(F), to_float(Q), to_float(F_noop), to_float(Q_noop), season_length)
end

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

    function transition(c::Seasonal{T}, x::Vector{T}, t::Integer) where T

Deterministic transition of state $x$ for time step $t$.

"""
function transition(c::Seasonal{T}, x, t::U) where {T, U <: Integer}
    F, _ = _transition_mats(c, t)
    return F*x
end
transition(c::Seasonal{T}, x, t::U, params) where {T, U <: Integer} = transition(c, x, t)

@doc raw"""

    function transition(c::Seasonal{T}, x::Vector{T}, P::Matrix{T}, t::Integer) where T

Probabilistic transition of state with mean $x$ and covariance $P$ for time step $t$.

"""
function transition(c::Seasonal{T}, x, P, t) where T
    F, Q = _transition_mats(c, t)
    x = F*x
    P = F*P*F' + Q
    return x, P
end
transition(c::Seasonal{T}, x, P, t::U, params) where {T, U <: Integer} = transition(c, x, P, t)
