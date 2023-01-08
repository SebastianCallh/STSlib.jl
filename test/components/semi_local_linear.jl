@testset "local_linear" begin

    @testset "transition probabilistic" begin
        m = SemiLocalLinear(1, 1)
        x = [1., 2.]
        P = diagm(ones(length(x)))
        R = [0.15;;]

        params = [.5, 1]
        x₁, P₁ = transition(m, x, P, params)
        y₁, S₁ = observe(m, x₁, P₁, R)
        @test only(y₁) == x₁[1] # observe level

        @test x₁ == [3.5, 1.5]
        @test P₁ == [3.0 0.5; 0.5 1.25]
        @test S₁ == [3.15;;]
        @test eltype(x₁) == eltype(x)
        @test eltype(y₁) == eltype(x)    
    end

    @testset "callable with time"  begin

    end

    @testset "equality" begin
        m1 = SemiLocalLinear(1., 1.)
        m2 = SemiLocalLinear(2., 1.)
        m3 = SemiLocalLinear(1, 1)
        @test m1 == m1
        @test m1 != m2
        @test m1 == m3
    end

    @testset "size" begin
        m = SemiLocalLinear(1, 2)
        @test latent_size(m) == 2
    end

    @testset "params" begin
        m = SemiLocalLinear(1, 2)
        @test num_params(m) == 2
    end

    @testset "observation matrix" begin
        m = SemiLocalLinear(1, 2)
        H = observation_matrix(m)
        @test H == [1. 0.;]
    end
end