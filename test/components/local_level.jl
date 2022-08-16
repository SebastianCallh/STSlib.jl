@testset "local_level" begin

    @testset "transition" begin
        m = LocalLevel()
        x = [2.]
        
        x₁, H = m(x, 1)
        y₁ = observe(x₁, H)
        @test only(y₁) == x₁[1] # observe level
        @test x₁ == [2] # constant level
    end

    @testset "equality" begin
        m1 = LocalLevel(1)
        m2 = LocalLevel(2)
        m3 = LocalLevel(1)
        @test m1 == m1
        @test m1 != m2
        @test m1 == m3
    end

    @testset "size" begin
        m = LocalLevel(1)
        @test latent_size(m) == 1
    end
end
