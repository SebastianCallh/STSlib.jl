@doc raw"""

GaussianLinear(H::Matrix{T}, F::Matrix{T}, Q::Matrix{T}) where T <: AbstractFloat

Gausssian linear state space model with observation matrix $H$,
transition matrix $F$ and transition covariance matrix $Q$.

"""
struct GaussianLinear{T, U <: AbstractMatrix{T}, V <: AbstractMatrix{T}} <: AbstractComponent{T}
    H::U
    F::V
    Q::V
end

num_params(c::GaussianLinear) = 0
Base.:(==)(c1::GaussianLinear, c2::GaussianLinear) = all([
    c1.H == c2.H,
    c1.F == c2.F,
    c1.Q == c2.Q,
])

@doc raw"""

    transition(c::GaussianLinear{T}, x::Vector{T}) where T

Deterministic transition of state $x$.

"""
function transition(c::GaussianLinear{T}, x) where {T}
    (;F) = c
    return F*x
end
transition(c::GaussianLinear{T}, x, t::V) where {T, V <: Integer} = transition(c, x)
transition(c::GaussianLinear{T}, x, t::V, params) where {T, V <: Integer} = transition(c, x)

@doc raw"""

    transition(c::GaussianLinear{T}, x::Vector{T}, P::Matrix{T}) where T

Probabilistic transition of state with mean $x$ and covariance $P$.

"""
function transition(c::GaussianLinear{T}, x, P) where {T}
    (;F, Q) = c
    x = F*x
    P = F*P*F' + Q
    return x, P
end
transition(c::GaussianLinear{T}, x, P, t::V) where {T, V <: Integer} = transition(c, x, P)
transition(c::GaussianLinear{T}, x, P, t::V, params) where {T, V <: Integer} = transition(c, x, P)