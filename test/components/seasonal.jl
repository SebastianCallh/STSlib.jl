@testset "seasonal" begin
    drift_scale = 0.1
    num_seasons = 4
    season_length = 2
    sts = Seasonal(num_seasons, season_length, drift_scale)
    x = collect(1:4)
    
    F₁, H₁, Q₁ = sts(season_length+1)
    x₁ = H₁*x
    y₁ = F₁*x₁
    @test only(y₁) == x₁[1] # observe first effect
    @test all(x₁ .== x[[2, 3, 4, 1]]) # cycle seasons
    @test all(diag(Q₁) .== vcat(drift_scale.^2, zeros(num_seasons-1))) # new season => drift scale
    
    F₂, H₂, Q₂ = sts(season_length)
    x₂ = H₂*x₁
    y₂ = F₂*x₂
    @test all(Q₂ .== 0) # no new season => no drift scale
end