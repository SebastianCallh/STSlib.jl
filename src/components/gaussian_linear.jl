@doc raw"""

GaussianLinear(H::Matrix{T}, F::Matrix{T}, Q::Matrix{T}) where T <: AbstractFloat

Gausssian linear state space model with observation matrix $H$,
transition matrix $F$ and transition covariance matrix $Q$.

"""
abstract type GaussianLinear{T} <: Component{T}
end

latent_size(c::GaussianLinear) = size(c.H, 2)
num_params(c::GaussianLinear) = 0
Base.:(==)(c1::GaussianLinear, c2::GaussianLinear) = all([
    c1.H == c2.H,
    c1.F == c2.F,
    c1.Q == c2.Q,
])

@doc raw"""

    function (c::GaussianLinear{T})(x::Vector{T}, t::Integer) where T

Deterministic transition of state $x$.

"""
function (c::GaussianLinear{T})(x::Vector{T}, args...) where T
    (;F, H) = c
    x = transition(x, F)
    #y = observe(x, H)
    return x, H # y
end

@doc raw"""

    function (c::GaussianLinear{T})(x::Vector{T}, t::Integer) where T

Probabilistic transition of state with mean $x$ and covariance $P$.

"""
function (c::GaussianLinear{T})(x::Vector{T}, P::Matrix{T}, args...) where T
    (;H, F, Q) = c
    x, P = transition(x, P, F, Q)
    #y, S = observe(x, P, H, R)
    return x, P, H # y, S
end

function observe(x, H)
    return H*x
end

function observe(x, P, H, R)
    y = H*x
    S = H*P*H' + R
    return y, S
end

function transition(x, F)
    return F*x
end

function transition(x, P, F, Q)
    x = F*x
    P = F*P*F' + Q
    return x, P
end