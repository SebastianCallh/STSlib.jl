abstract type Component{T <: AbstractFloat} end

Base.:(+)(c1::Component{T}, c2::Component{T}) where T = Sum{T}([c1, c2], reduce(hcat, [c1.H, c2.H]))

"""
    simulate(sts::Component, steps, x₀, P₀, σ; compound_uncertainty = true)

Simulates from the provided `model` for `steps` time steps
with initial state mean `x` with covariance matrix `P` and observation noise `σ`.
If `compound_uncertainty` is `true` the result will be a randomly sampled trajectory.
If `compound_uncertainty` is `false`, covariance `P` will not accumulate.
"""
function simulate(sts, steps, x₀, P₀, σ; compound_uncertainty = true)
    R = [σ;;]
    T = eltype(x₀)
    latent_dim = latent_size(sts)
    obs_dim = size(R, 1)
    xs = Matrix{T}(undef, latent_dim, steps)
    ys = Matrix{T}(undef, obs_dim, steps)
    xs[:, 1] = x₀
    x, P = copy(x₀), copy(P₀)
    for t in 1:size(xs, 2)
        x, Pₜ = transition(sts, xs[:,max(t-1, 1)], P, t)
        y, S = observe(sts, x, P, R)
        xs[:,t] = rand(Gaussian(x, P))
        ys[:,t] = rand(Gaussian(y, S))

        if compound_uncertainty 
            P .= Pₜ
        end
    end

    return xs, ys
end