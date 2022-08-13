@testset "autoregressive" begin
    
    @testset "transition" begin
        m = Autoregressive(2, .1)
        x = [1., 2.]
        β = [2., 2.]
        H, F, Q = m(x, β, 1)
        x₁ = F*x
        y₁ = H*x₁
        @test x₁ == β'*x
        @test only(y₁) == x₁[1]
    end

    @testset "equality" begin
        m1 = Autoregressive(12, .1)
        m2 = Autoregressive(1, .1)
        m3 = Autoregressive(12, .2)
        m4 = Autoregressive(12, .1)
        @test m1 == m1
        @test m1 != m2
        @test m1 != m3
        @test m1 == m4
    end
    
    @testset "size" begin
        order = 32
        m = Autoregressive(order, .1)
        @test latent_size(m) == order
    end

    @testset "number of params" begin
        order = 123
        m = Autoregressive(order, .1) 
        @test num_params(m) == order
    end
end