struct Sum{T, C1 <: AbstractComponent{T}, C2 <: AbstractComponent{T}, X <: AbstractMatrix{T}} <: AbstractComponent{T}
    component1::C1
    component2::C2
    H::X
end

Base.:(+)(c1::U, c2::V) where {U <: AbstractComponent, V <: AbstractComponent} = begin
    H = hcat(observation_matrix(c1), observation_matrix(c2))
    Sum(c1, c2, H)
end

observation_matrix(c::Sum) = c.H
latent_size(c::Sum) = latent_size(c.component1) + latent_size(c.component2)
num_params(c::Sum) = num_pa(c.component1) + num_params(c.component2)

@doc raw"""

    function observe(c::Sum{T}, x::Vector) where T

Deterministic observation of state $x$.

"""
function observe(c::Sum{U, T}, x) where {U, T}
    (;H) = c
    return H*x
end

@doc raw"""

    function observe(c::Sum{T}, x::Vector, P::Matrix, R::Matrix) where T

Probabilistic observation of state with mean $x$, covariance $P$ and observation noise covariance $R$.

"""
function observe(c::Sum{U, T}, x, P, R) where {U, T}
    (;H) = c
    y = H*x
    S = H*P*H' + R
    return y, S
end

@doc raw"""

    function transition(c::Sum{T}, x::Vector, t::Integer) where T

Deterministic transition of state $x$ for time step $t$.
The time step parameter $t$ is forwarded to time dependent components.

"""
function transition(c::Sum{U, T}, x, t) where {U, T}
    size1 = latent_size(c.component1)

    x1 = @view x[begin:size1]
    x2 = @view x[size1+1:end]
    x1 = transition(c.component1, x1, t)
    x2 = transition(c.component2, x2, t)    
    x = vcat(x1, x2)
    return x
end

@doc raw"""

    function transition(c::Sum{T}, x::Vector, P::Matrix) where T

Probabilistic transition of state with mean $x$ and covariance $P$ for time step $t$.
The time step parameter $t$ is forwarded to time dependent components.

"""
function transition(c::Sum{U, T}, x, P, t) where {U, T}
    size1 = latent_size(c.component1)
    
    x1 = @view x[begin:size1]
    x2 = @view x[size1+1:end]
    P1 = @view P[begin:size1,begin:size1]
    P2 = @view P[size1+1:end,size1+1:end]
    
    x1, P1 = transition(c.component1, x1, P1, t)
    x2, P2 = transition(c.component2, x2, P2, t)    
    x = vcat(x1, x2)
    P = blockdiagonal(P1, P2)
    return x, P
end