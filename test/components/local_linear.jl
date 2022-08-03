@testset "local_linear" begin
    m = LocalLinear()
    x = [1, 2]
    
    F, H, Q = m(1)
    x₁ = H*x
    y₁ = F*x₁
    @test only(y₁) == x₁[1] # observe level
    @test all(x₁ .== [3, 2])
end