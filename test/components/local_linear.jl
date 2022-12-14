@testset "local_linear" begin

    @testset "transition probabilistic" begin
        m = LocalLinear(1, 1)
        x = [1., 2.]
        P = diagm(ones(length(x)))
        R = [0.15;;]

        x₁, P₁ = transition(m, x, P)
        y₁, S₁ = observe(m, x₁, P₁, R)
        @test only(y₁) == x₁[1] # observe level
        @test x₁ == [3., 2.]
        @test P₁ == [3.0 1.0; 1.0 2.0]
        @test S₁ == [3.15;;]
        @test eltype(x₁) == eltype(x)
        @test eltype(y₁) == eltype(x)
    end

    @testset "callable with time"  begin
        m = LocalLinear(1, 1)
        x = [1., 2.]
        P = diagm(ones(length(x)))
        R = [0.15;;]
        t = 1

        x₁, P₁ = transition(m, x, P)
        x₂, P₂ = transition(m, x, P, t)
        @test x₁ == x₂
        @test P₁ == P₂
    end

    @testset "equality" begin
        m1 = LocalLinear(1., 1.)
        m2 = LocalLinear(2., 1.)
        m3 = LocalLinear(1, 1)
        @test m1 == m1
        @test m1 != m2
        @test m1 == m3
    end

    @testset "size" begin
        m = LocalLinear(1, 2)
        @test latent_size(m) == 2
    end

    @testset "params" begin
        m = LocalLinear(1, 2)
        @test num_params(m) == 0
    end

    @testset "observation matrix" begin
        m = LocalLinear(1, 2)
        H = observation_matrix(m)
        @test H == [1. 0.;]
    end
end