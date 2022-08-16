"""

Sum{T(components::Vector{Component{T}}) where T <: AbstractFloat

"""
struct Sum{T} <: Component{T}
    components::Vector{Component{T}}
end

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

function (m::Sum{T})(x::Vector{T}, t::Integer) where T
    sizes = latent_size.(m.components)
    xs = _chunk(x, sizes)
    results = [c(x, t) for (c, x) in zip(m.components, xs)]

    x = reduce(vcat, [r[1] for r in results])
    H = reduce(hcat, [r[2] for r in results])
    # y = observe(x, H)
    # y = reduce(vcat, [r[2] for r in results])
    return x, H
end

function (m::Sum{T})(x::Vector{T}, P::Matrix{T}, t::Integer) where T
    sizes = latent_size.(m.components)
    xs = _chunk(x, sizes)
    Ps = _chunk(P, sizes)
    results = [c(x, P, t) for (c, x, P) in zip(m.components, xs, Ps)]

    x = reduce(vcat, [r[1] for r in results])
    P = blockdiagonal([r[2] for r in results])
    H = reduce(hcat, [r[3] for r in results])
    # @show size.((x, P, H, R))
    # @show H
    # y, S = observe(x, P, sum(H; dims=1), R)
    return x, P, H # , y, S
end