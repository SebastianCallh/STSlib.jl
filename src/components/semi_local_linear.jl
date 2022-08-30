struct SemiLocalLinear{T, U <: AbstractMatrix{T}, V <: AbstractMatrix{T}} <: AbstractComponent{T}
    H::U
    Q::V
end

"""

    SemiLocalLinear(level_scale::T, slope_scale::U) where {T, U}

"""
function SemiLocalLinear(level_scale::T, slope_scale::U) where {T, U}
    H = SA[1. 0.]
    Q = SA[convert(float(T), level_scale) 0; 0 convert(float(U), slope_scale)]    
    SemiLocalLinear(H, Q)
end

num_params(c::SemiLocalLinear) = 1

transition(c::SemiLocalLinear, x, t::U, params) where {U <: Integer} = transition(c, x, params)
function transition(c::SemiLocalLinear, x, params::T) where {T <: AbstractVector}
    level = x[1] + x[2]
    coeff, slope_mean = params
    slope = slope_mean + coeff*(x[2] - slope_mean)
    x = SA[level, slope]
    return x
end

transition(c::SemiLocalLinear, x, P, t::U, params) where {U <: Integer} = transition(c, x, P, params)
function transition(c::SemiLocalLinear, x, P, params::T) where {T <: AbstractVector}
    level = x[1] + x[2]
    coef, slope_mean = params
    slope = slope_mean + coef*(x[2] - slope_mean)
    x = SA[level, slope]
    F = SA[1. 1.; 0. coef]
    P = F*P*F' + c.Q
    x, P
end