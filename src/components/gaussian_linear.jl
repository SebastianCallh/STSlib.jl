@doc raw"""

GaussianLinear(H::Matrix{T}, F::Matrix{T}, Q::Matrix{T}) where T <: AbstractFloat

Gausssian linear state space model encoding 

$$$x_{t+1} = Fx_t + \epsilon, \epsilon \sim \mathcal{N}(b, Q)$$$

with observation matrix $H$,
transition matrix $F$ and transition covariance matrix $Q$.

"""
struct GaussianLinear{T, U <: AbstractMatrix{T}, V <: AbstractVector{T}, X <: AbstractMatrix{T}} <: AbstractComponent{T}
    H::U
    b::V
    F::X
    Q::X
end

num_params(c::GaussianLinear) = 0

@doc raw"""

    transition(c::GaussianLinear{T}, x::Vector{T}, P::Matrix{T}) where T

Probabilistic transition of state with mean $x$ and covariance $P$.

"""
function transition(c::GaussianLinear{T}, x, P) where {T}
    (;F, b, Q) = c
    x = F*x + b
    P = F*P*F' + Q
    return x, P
end
transition(c::GaussianLinear{T}, x, P, t::V) where {T, V <: Integer} = transition(c, x, P)
transition(c::GaussianLinear{T}, x, P, t::V, params) where {T, V <: Integer} = transition(c, x, P)