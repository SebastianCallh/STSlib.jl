@testset "component" begin

    @testset "simulate" begin
        sts = LocalLinear(1, 1) + Seasonal(2, 1, 1)
        steps = 4
        σ = 0.15
        x₀ = rand(latent_size(sts))
        P = diagm(ones(latent_size(sts)))
        xs, ys = simulate(sts, steps, x₀, P, σ)
        @test size(xs) == (4, steps)
        @test size(ys) == (1, steps)
        @test eltype(xs) == eltype(x₀)
        @test eltype(ys) == eltype(x₀)
    end
end