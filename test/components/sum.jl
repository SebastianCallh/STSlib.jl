@testset "sum" begin
    
    @testset "construction" begin
        c₁ = LocalLevel(1)
        c₂ = LocalLevel(1)
        m = c₁ + c₂

        @test m.component1 == c₁
        @test m.component2 == c₂
    end

    @testset "transition probabilistic" begin
        m = LocalLevel(1) + Seasonal(3, 1, 1)
        x = [1., 1., 2., 0.]
        P = diagm(ones(length(x)))
        R = [0.1;;]
        x₁, P₁ = transition(m, x, P, 1)
        y₁, S = observe(m, x₁, P₁, R)
        
        @test P₁ == Float64[2 0 0 0; 0 1 0 0 ; 0 0 1 0; 0 0 0 1]
        @test only(y₁) == x₁[1] + x₁[2] # observe level plus season effect
        @test x₁ == x # constant state        
        @test S == [3.1;;]
    end

    @testset "equality" begin
        m1 = LocalLinear(1, 1) + Seasonal(1, 1, 1)
        m2 = LocalLinear(2, 1)
        m3 = LocalLinear(2, 1) + Seasonal(2, 2, 2)
        m4 = LocalLinear(1., 1.) + Seasonal(1, 1, 1)
        @test m1 == m1
        @test m1 != m2
        @test m1 != m3
        @test m1 == m4
    end
    
    @testset "size" begin
        num_seasons = 5
        c1 = LocalLinear(1., 1.)
        c2 = Seasonal(num_seasons, 2, 1)
        m = c1 + c2
        @test latent_size(m) == latent_size(c1) + latent_size(c2)
    end
        
    @testset "observation matrix" begin
        m = LocalLevel(1.) + Seasonal(3, 1, 1)
        H = observation_matrix(m)
        @test H == [1. 1. 0. 0.]
    end
        
    @testset "params" begin
        c1 = LocalLevel(1.) 
        c2 = LocalLinear(3, 1)
        m = c1 + c2
        @test num_params(m) == num_params(c1) + num_params(c2)
    end

    @testset "nested sums" begin
        m1 = LocalLevel(1.) + Seasonal(3, 1, 1)
        m2 = LocalLinear(1., 2.)
        m = m1 + m2

        H = observation_matrix(m)
        @test H == [1. 1. 0. 0. 1. 0]
        
        x = [1., 2., 0., 0., 1., 1.]
        P = diagm(ones(length(x)))

        R = [0.1;;]
        x₁, P₁ = transition(m, x, P, 1)
        y₁, S₁ = observe(m, x₁, P, R)
        @test S₁ == [3.1;;]
        @test P₁ == Float64[2 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 3 1; 0 0 0 0 1 5]
        @test only(y₁) == x₁[1] + x₁[2] + x₁[5]
    end
end