"""

Sum{T(components::Vector{Component{T}}) where T <: AbstractFloat

"""
struct Sum{T} <: Component{T}
    components::Vector{Component{T}}
    H::Matrix{T}
end

function Sum(components::Vector{Component{T}}) where T    
    H = reduce(hcat, [c.H for c in components])
    return Sum{T}(components, H)
end

observation_matrix(c::Sum) = c.H
latent_size(m::Sum) = reduce(+, latent_size.(m.components))
num_params(m::Sum) = reduce(+, num_params.(m.components))
Base.length(m::Sum) = length(m.components)
Base.:(==)(c1::Sum, c2::Sum) = all(c1.components .== c2.components)

function _make_indices(sizes)
    collect(zip(vcat(0, sizes) .+ 1, cumsum(sizes)))
end

"""Chunks a vector into components which sizes are determined by `sizes`."""
function _chunk(x::T, sizes) where T <: AbstractVector
    indices = _make_indices(sizes)
    chunks = [x[i:j] for (i, j) in indices]
    return chunks
end

"""Chunks a matrix into block matrix components"""
function _chunk(x::T, sizes) where T <: AbstractMatrix
    indices = _make_indices(sizes)
    chunks = [x[i:j, i:j] for (i, j) in indices]
    return chunks
end

@doc raw"""

    function observe(c::Sum{T}, x::Vector{T}) where T

Deterministic observation of state $x$.

"""
function observe(c::Sum{T}, x::Vector{T}) where T
    (;H) = c
    return H*x
end

@doc raw"""

    function observe(c::Sum{T}, x::Vector{T}, P::Matrix{T}, R::Matrix{T}) where T

Probabilistic observation of state with mean $x$, covariance $P$ and observation noise covariance $R$.

"""
function observe(c::Sum{T}, x::Vector{T}, P::Matrix{T}, R::Matrix{T}) where T
    (;H) = c
    y = H*x
    S = H*P*H' + R
    return y, S
end

@doc raw"""

    function transition(c::Sum{T}, x::Vector{T}, t::Integer) where T

Deterministic transition of state $x$ for time step $t$.
The time step parameter $t$ is forwarded to time dependant components.

"""
function transition(c::Sum{T}, x::Vector{T}, t::Integer) where T
    sizes = latent_size.(c.components)
    xs = _chunk(x, sizes)
    x = reduce(vcat, transition.(c.components, xs, Ref(t)))
    return x
end

@doc raw"""

    function transition(c::Sum{T}, x::Vector{T}, P::Matrix{T}) where T

Probabilistic transition of state with mean $x$ and covariance $P$ for time step $t$.
The time step parameter $t$ is forwarded to time dependant components.

"""
function transition(c::Sum{T}, x::Vector{T}, P::Matrix{T}, t::Integer) where T
    sizes = latent_size.(c.components)
    xs = _chunk(x, sizes)
    Ps = _chunk(P, sizes)
    results = reduce(vcat, transition.(c.components, xs, Ps, Ref(t)))
    x = reduce(vcat, [r[1] for r in results])
    P = blockdiagonal([r[2] for r in results])
    return x, P
end