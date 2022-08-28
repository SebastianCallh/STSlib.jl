abstract type AbstractComponent{T <: AbstractFloat} end

"""
    simulate(sts::Component, steps, x₀, P₀, σ; compound_uncertainty = true)

Simulates from the provided `model` for `steps` time steps
with initial state mean `x` with covariance matrix `P` and observation noise `σ`.
If `compound_uncertainty` is `true` the result will be a randomly sampled trajectory.
If `compound_uncertainty` is `false`, covariance `P` will not accumulate.
"""
function simulate(sts, steps, x₀, P₀, σ; compound_uncertainty = true)
    R = @SMatrix [σ;;]
    T = eltype(x₀)
    N = latent_size(sts)
    M = size(R, 1)
    xs = [SVector{N, T}(zeros(N)) for _ in 1:steps]
    ys = [SVector{M, T}(zeros(M)) for _ in 1:steps]
    xs[1] = x₀

    x = SVector{length(x₀)}(x₀)
    P = MMatrix{N, N}(P₀)
    for t in 1:steps
        x, Pₜ = transition(sts, xs[max(t-1, 1)], P, t)
        y, S = observe(sts, x, P, R)
        xs[t] = rand(Gaussian(x, P))
        ys[t] = rand(Gaussian(y, S))

        if compound_uncertainty 
            P .= MMatrix{N, N}(Pₜ)
        end
    end

    return reduce(hcat, xs), reduce(hcat, ys)
end