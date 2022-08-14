@doc raw"""

GaussianLinear(H::Matrix{T}, F::Matrix{T}, Q::Matrix{T}) where T <: AbstractFloat

Gausssian linear state space model with observation matrix $H$,
transition matrix $F$ and transition covariance matrix $Q$.

"""
struct GaussianLinear{T} <: Component{T}
    H::Matrix{T}
    F::Matrix{T}
    Q::Matrix{T}
end

latent_size(c::GaussianLinear) = size(c.H, 2)
Base.:(==)(c1::GaussianLinear, c2::GaussianLinear) = all([
    c1.H == c2.H,
    c1.F == c2.F,
    c1.Q == c2.Q,
])

function (c::GaussianLinear{T})(x::Vector{T}, args...) where T
    (;H, F, Q) = c
    return H, F, Q
end    