@testset "local_level" begin

    @testset "transition probabilistic" begin
        m = LocalLevel(1)
        x = [2.]
        P = diagm(ones(length(x)))
        R = [0.15;;]

        x₁, P₁ = transition(m, x, P)
        y₁, S₁ = observe(m, x₁, P₁, R)
        @test only(y₁) == x₁[1] # observe level
        @test x₁ == [2.]
        @test P₁ == [2.0;;]
        @test S₁ == [2.15;;]
        @test eltype(x₁) == eltype(x)
        @test eltype(y₁) == eltype(x)
    end
        
    @testset "callable with time"  begin
        m = LocalLevel(1)
        x = [1.]
        P = diagm(ones(length(x)))
        R = [0.15;;]
        t = 1

        x₁, P₁ = transition(m, x, P)
        x₂, P₂ = transition(m, x, P, t)
        @test x₁ == x₂
        @test P₁ == P₂
        @test eltype(x₁) == eltype(x)
        @test eltype(x₂) == eltype(x)
    end

    @testset "equality" begin
        m1 = LocalLevel(1.)
        m2 = LocalLevel(2.)
        m3 = LocalLevel(1)
        @test m1 == m1
        @test m1 != m2
        @test m1 == m3
    end

    @testset "size" begin
        m = LocalLevel(1.)
        @test latent_size(m) == 1
    end

    @testset "params" begin
        m = LocalLevel(1)
        @test num_params(m) == 0
    end

    @testset "observation matrix" begin
        m = LocalLevel(1.)
        H = observation_matrix(m)
        @test H == [1;;]
    end
end
