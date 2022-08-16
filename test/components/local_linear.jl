@testset "local_linear" begin

    @testset "transition deterministic" begin
        m = LocalLinear()
        x = [1., 2.]
        
        x₁ = transition(m, x)
        y₁ = observe(m, x₁)
        @test only(y₁) == x₁[1] # observe level
        @test x₁ == [3., 2.]
    end

    @testset "transition probabilistic" begin
        m = LocalLinear()
        x = [1., 2.]
        P = diagm(ones(length(x)))
        R = [0.15;;]

        x₁, P₁ = transition(m, x, P)
        y₁, S₁ = observe(m, x₁, P₁, R)
        @test only(y₁) == x₁[1] # observe level
        @test x₁ == [3., 2.]
        @test P₁ == [3.0 1.0; 1.0 2.0]
        @test S₁ == [3.15;;]
    end

    @testset "callable with time"  begin
        m = LocalLinear()
        x = [1., 2.]
        P = diagm(ones(length(x)))
        R = [0.15;;]
        t = 1

        x₁ = transition(m, x)
        x₂ = transition(m, x, t)
        @test x₁ == x₂

        x₁, P₁ = transition(m, x, P)
        x₂, P₂ = transition(m, x, P, t)
        @test x₁ == x₂
        @test P₁ == P₂
    end

    @testset "equality" begin
        m1 = LocalLinear(1, 1)
        m2 = LocalLinear(2, 1)
        m3 = LocalLinear(1)
        @test m1 == m1
        @test m1 != m2
        @test m1 == m3
    end

    @testset "size" begin
        m = LocalLinear(1)
        @test latent_size(m) == 2
    end
end