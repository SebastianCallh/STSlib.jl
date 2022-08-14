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

function (m::Sum{T})(x::Vector{T}, args...) where T
    sizes = cumsum(latent_size.(m.components))
    indices = collect(zip(vcat(0, sizes) .+ 1, sizes))
    xs = [x[i:j] for (i, j) in indices]
    results = [c(x, args...) for (c, x) in zip(m.components, xs)]

    x = reduce(vcat, [r[1] for r in results])
    y = reduce(vcat, [r[2] for r in results])
    return x, sum(y)
end