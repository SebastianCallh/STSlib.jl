struct SemiLocalLinear{T, U <: AbstractMatrix{T}, V <: AbstractMatrix{T}} <: AbstractComponent{T}
    H::U
    Q::V
end

"""

    SemiLocalLinear(level_scale::T, slope_scale::U) where {T, U}

"""
function SemiLocalLinear(level_scale, slope_scale)
    H = SA[1. 0.]
    Q = SA[level_scale^2 0.; 0. slope_scale^2]
    SemiLocalLinear(H, Q)
end

num_params(c::SemiLocalLinear) = 2

transition(c::SemiLocalLinear, x, P, t, params) = transition(c, x, P, params)
function transition(c::SemiLocalLinear, x, P, params)
    coef, slope_mean = params
    F = SA[1. 1.; 0. coef]
    b = slope_mean - coef*slope_mean
    x = F*x .+ b
    P = F*P*F' + c.Q
    x, P
end