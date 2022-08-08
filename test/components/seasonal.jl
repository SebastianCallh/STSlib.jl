@testset "seasonal" begin

    @testset "transition" begin
        drift_scale = 0.1
        num_seasons = 4
        season_length = 2
        sts = Seasonal(num_seasons, season_length, drift_scale)
        x = collect(1:4)
        
        F₁, H₁, Q₁ = sts(season_length+1)
        x₁ = H₁*x
        y₁ = F₁*x₁
        @test only(y₁) == x₁[1] # observe first effect
        @test x₁ == x[[2, 3, 4, 1]] # cycle seasons
        @test diag(Q₁) == vcat(drift_scale.^2, zeros(num_seasons-1)) # new season => drift scale
        
        F₂, H₂, Q₂ = sts(season_length)
        x₂ = H₂*x₁
        y₂ = F₂*x₂
        @test x₂ == x₁ # do not cycle seasons
        @test diag(Q₂) == zeros(num_seasons) # no new season => no drift scale
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
        @test observed_size(m) == 1
    end
end