struct Sum{T, C1 <: AbstractComponent{T}, C2 <: AbstractComponent{T}, X <: AbstractMatrix{T}} <: AbstractComponent{T}
    component1::C1
    component2::C2
    H::X
end

Base.:(+)(c1::U, c2::V) where {U <: AbstractComponent, V <: AbstractComponent} = begin
    H = hcat(observation_matrix(c1), observation_matrix(c2))
    Sum(c1, c2, H)
end

latent_size(c::Sum) = latent_size(c.component1) + latent_size(c.component2)
num_params(c::Sum) = num_params(c.component1) + num_params(c.component2)

@doc raw"""

    function transition(c::Sum{T}, x::Vector, P::Matrix) where T

Probabilistic transition of state with mean $x$ and covariance $P$ for time step $t$.
The time step parameter $t$ is forwarded to time dependent components.

"""
function transition(c::Sum, x, P, t, params)
    size1 = latent_size(c.component1)
    nparams1 = num_params(c.component1)
    
    x1 = @view x[begin:size1]
    x2 = @view x[size1+1:end]
    P1 = @view P[begin:size1,begin:size1]
    P2 = @view P[size1+1:end,size1+1:end]
    params1 = @view params[begin:nparams1]
    params2 = @view params[nparams1+1:end]
    
    x1, P1 = transition(c.component1, x1, P1, t, params1)
    x2, P2 = transition(c.component2, x2, P2, t, params2)
    x = vcat(x1, x2)
    P = blockdiagonal(P1, P2)
    return x, P
end
transition(c::Sum, x, P, t) = transition(c, x, P, t, SA{typeof(x)}[])