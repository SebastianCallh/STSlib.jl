@testset "seasonal" begin
  
    @testset "transition probabilistic" begin
        drift_scale = 0.1
        num_seasons = 4
        season_length = 2
        m = Seasonal(num_seasons, season_length, drift_scale)
        x = Float64.(collect(1:4))
        P = diagm(ones(4))
        R = [1.0;;]
        x₁, P₁ = transition(m, x, P, season_length+1)
        y₁, S₁ = observe(m, x₁, P₁, R)
        @test only(y₁) == x₁[1] # observe first effect
        @test x₁ == x[[2, 3, 4, 1]] # cycle seasons
        @test P₁ == [1.01 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
        @test S₁ == [2.01;;]
        @test eltype(x₁) == eltype(x)
        @test eltype(y₁) == eltype(x)

        x₂, P₂ = transition(m, x, P, season_length)
        y₂, S₂ = observe(m, x₂, P, R)
        @test x₂ == x # do not cycle seasons
        @test P₂ == [1.0 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
        @test S₂ == [2.0;;]
        @test eltype(x₂) == eltype(x)
        @test eltype(y₂) == eltype(x)
    end
    

    @testset "equality" begin
        m1 = Seasonal(1, 1, 1)
        m2 = Seasonal(2, 1, 1)
        m3 = Seasonal(1, 2, 1)
        m4 = Seasonal(1, 1, 2)
        m5 = Seasonal(1, 1, 1)
        @test m1 == m1
        @test m1 != m2
        @test m1 != m3
        @test m1 != m4
        @test m1 == m5
    end
    
    @testset "size" begin
        num_seasons = 5
        m = Seasonal(num_seasons, 2, 1)
        @test latent_size(m) == num_seasons
    end

    @testset "observation matrix" begin
        m = Seasonal(5, 2, 1)
        H = observation_matrix(m)
        @test H == [1. 0. 0. 0. 0.]
    end
end