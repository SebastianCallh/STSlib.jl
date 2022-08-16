@testset "seasonal" begin

    @testset "transition" begin
        drift_scale = 0.1
        num_seasons = 4
        season_length = 2
        m = Seasonal(num_seasons, season_length, drift_scale)
        x = Float64.(collect(1:4))
        
        x₁, H = m(x, season_length+1)
        y₁ = observe(x₁, H)
        @test only(y₁) == x₁[1] # observe first effect
        @test x₁ == x[[2, 3, 4, 1]] # cycle seasons
        # @test diag(Q₁) == vcat(drift_scale.^2, zeros(num_seasons-1)) # new season => drift scale
        
        x₂, y₂ = m(x, season_length)
        @test x₂ == x # do not cycle seasons
        # @test diag(Q₂) == zeros(num_seasons) # no new season => no drift scale
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
end