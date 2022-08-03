@testset "sum" begin
    @testset "construction" begin
        c₁ = LocalLevel()
        c₂ = LocalLevel()
        m₁ = c₁ + c₂
        m₂ = Sum([c₁, c₂])

        @test m₁ == m₂
    end

    @testset "transition" begin
        m = LocalLevel() + Seasonal(2, 1, 1)
        x = [1, 2, 0]
        F, H, Q = m(1)
        x₁ = H*x
        y₁ = F*x₁
        @test only(y₁) == x₁[1] + x₁[2] # observe level plus season effect
        @test x₁ == [1, 2, 0] # constant state        
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
end