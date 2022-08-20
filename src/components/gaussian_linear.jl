@doc raw"""

GaussianLinear(H::Matrix{T}, F::Matrix{T}, Q::Matrix{T}) where T <: AbstractFloat

Gausssian linear state space model with observation matrix $H$,
transition matrix $F$ and transition covariance matrix $Q$.

"""
struct GaussianLinear{T, M, N} <: Component{T}
    H::SMatrix{M, N, T}
    F::SMatrix{N, N, T}
    Q::SMatrix{N, N, T}
end

observation_matrix(c::GaussianLinear) = c.H
latent_size(c::GaussianLinear{T, M, N}) where  {T, M, N} = N
num_params(c::GaussianLinear) = 0
Base.:(==)(c1::GaussianLinear, c2::GaussianLinear) = all([
    c1.H == c2.H,
    c1.F == c2.F,
    c1.Q == c2.Q,
])

@doc raw"""

    function observe(c::GaussianLinear{T}, x::Vector{T}) where T

Deterministic observation of state $x$.

"""
function observe(c::GaussianLinear, x)
    (;H) = c
    return H*x
end

@doc raw"""

    function observe(c::GaussianLinear{T}, x::Vector{T}, P::Matrix{T}, R::Matrix{T}) where T

Probabilistic observation of state with mean $x$, covariance $P$ and observation noise covariance $R$.

"""
function observe(c::GaussianLinear, x, P, R)
    (;H) = c
    y = H*x
    S = H*P*H' + R
    return y, S
end

@doc raw"""

    function transition(c::GaussianLinear{T}, x::Vector{T}) where T

Deterministic transition of state $x$.

"""
function transition(c::GaussianLinear, x)
    (;F) = c
    return F*x
end
transition(c::GaussianLinear, x, t::Integer) = transition(c, x)

@doc raw"""

    function transition(c::GaussianLinear{T}, x::Vector{T}, P::Matrix{T}) where T

Probabilistic transition of state with mean $x$ and covariance $P$.

"""
function transition(c::GaussianLinear, x, P)
    (;F, Q) = c
    x = F*x
    P = F*P*F' + Q
    return x, P
end
transition(c::GaussianLinear, x, P, t::Integer) = transition(c, x, P)