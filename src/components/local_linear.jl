struct LocalLinear{T} <: GaussianLinear{T}
    H::Matrix{T}
    F::Matrix{T}
    Q::Matrix{T}
end

"""

    LocalLinear(level_scale::Real, slope_scale::Real)

"""
function LocalLinear(level_scale::T = 1., slope_scale::T = 1.) where T <: AbstractFloat
    LocalLinear(T[1 0], T[1 1; 0 1], diagm([level_scale^2, slope_scale^2]))
end

function LocalLinear(level_scale::Integer = 1, slope_scale::Integer = 1)
    LocalLinear(Float64(level_scale), Float64(slope_scale))
end