@testset "gaussian_linear" begin

    @testset "transition" begin
        m = GaussianLinear([1. 0.;], diagm([1., 2.]), diagm([0.1, 0.1]))
        x = [1., 2.]
        
        x₁, y₁ = m(x, 1)
        @test only(y₁) == x₁[1]
        @test x₁ == [1., 4.]
    end

    @testset "equality" begin
        m1 = GaussianLinear(diagm([1., 0.]), diagm([1., 1.]), diagm([0.1, 0.1]))
        m2 = GaussianLinear(diagm([1., 0.]), diagm([1., 2.]), diagm([0.1, 0.1]))
        m3 = GaussianLinear(diagm([1., 2.]), diagm([1., 1.]), diagm([0.1, 0.1]))
        m4 = GaussianLinear(diagm([1., 0.]), diagm([1., 1.]), diagm([0.1, 0.5]))
        m5 = GaussianLinear(diagm([1., 0.]), diagm([1., 1.]), diagm([0.1, 0.1]))
        @test m1 == m1
        @test m1 != m2
        @test m1 != m3
        @test m1 != m4
        @test m1 == m5
    end

    @testset "size" begin
        m = GaussianLinear(diagm([1., 1., 0.]), diagm([1., 1., 1.]), diagm([0.1, 0.1, 0.1]))
        @test latent_size(m) == 3
    end
end
