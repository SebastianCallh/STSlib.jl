@testset "sum" begin
    
    @testset "construction" begin
        c₁ = LocalLevel()
        c₂ = LocalLevel()
        m = c₁ + c₂

        @test m.components[1] == c₁
        @test m.components[2] == c₂
    end

    @testset "transition" begin
        m = LocalLevel() + Seasonal(2, 1, 1)
        x = [1., 2., 0.]
        x₁, y₁ = m(x, 1)
        @test y₁ == x₁[1] + x₁[2] # observe level plus season effect
        @test x₁ == x # constant state        
    end

    @testset "equality" begin
        m1 = LocalLinear(1) + Seasonal(1, 1, 1)
        m2 = LocalLinear(2)
        m3 = LocalLinear(2) + Seasonal(2, 2, 2)
        m4 = LocalLinear(1) + Seasonal(1, 1, 1)
        @test m1 == m1
        @test m1 != m2
        @test m1 != m3
        @test m1 == m4
    end
    
    @testset "size" begin
        num_seasons = 5
        m = LocalLinear(1, 1) + Seasonal(num_seasons, 2, 1)
        @test latent_size(m) == num_seasons + 2
    end
end