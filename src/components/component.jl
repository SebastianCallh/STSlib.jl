abstract type Component{T <: AbstractFloat} end

Base.:(+)(c1::Component{T}, c2::Component{T}) where T = Sum{T}([c1, c2])

"""
    simulate(model::Component, T, x, σ)

Simulates from the provided `model` for `steps` time steps
with initial state mean `x` with covariance matrix `P` and observation noise `σ`.
"""
function simulate(sts::Component, steps, x, P, σ; jitter=1e-8)
    R = [σ;;]
    T = eltype(x)
    latent_dim = latent_size(sts)
    obs_dim = size(R, 1)
    xs = Matrix{T}(undef, latent_dim, steps + 1)
    ys = Matrix{T}(undef, obs_dim, steps + 1)
    xs[:, 1] = x
    for t in 2:steps
        x, P, H = sts(xs[:,t-1], P, t)
        y, S = observe(x, P, H, R)
        xs[:,t] = rand(Gaussian(x, P .+ jitter .* abs.(diagm(randn(latent_dim)))))
        ys[:,t] = rand(Gaussian(y, S))
    end

    return xs[:,2:end], ys[:,2:end]
end