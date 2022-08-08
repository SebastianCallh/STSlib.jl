@testset "local_linear" begin

    @testset "transition" begin
        m = LocalLinear()
        x = [1, 2]
        
        F, H, Q = m(1)
        x₁ = H*x
        y₁ = F*x₁
        @test only(y₁) == x₁[1] # observe level
        @test x₁ == [3, 2]
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