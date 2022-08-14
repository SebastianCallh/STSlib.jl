struct Autoregressive{T} <: Component{T}
    H::Matrix{T}
    Q::Matrix{T}
    order::Int64
end

"""

    Autoregressive(order::Integer, level_scale::T) where T <: AbstractFloat

"""
function Autoregressive(order::Integer, level_scale::T) where T
    Autoregressive{T}(hcat(1, zeros(T, order-1)'), diagm([level_scale^2]), order)
end

latent_size(c::Autoregressive) = c.order
num_params(c::Autoregressive) = c.order
Base.:(==)(c1::Autoregressive, c2::Autoregressive) = all([
    c1.H == c2.H,
    c1.Q == c2.Q,
    c1.order == c2.order,
])

@doc raw"""

    (m::Autoregressive{T})(x::Vector{T}, β::Vector{T}, args...) where T

    Deterministic transition given state $x$ and coefficients $\beta$.

"""
function (c::Autoregressive{T})(x::Vector{T}, β::Vector{T}, args...) where T
    (;H) = c
    x = vcat(β'*x, x[begin:end-1])
    return x, H
end 