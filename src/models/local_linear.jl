"""

    LocalLinear()

"""
struct LocalLinear
    obs::Matrix{Int64}
    trans::Matrix{Int64}
    LocalLinear() = new([1 0], [1 1; 0 1])
end 
function (m::LocalLinear)(x::AbstractArray{T}, t::Integer) where T <: Real
    m.obs*x, m.trans*x
end
