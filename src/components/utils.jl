function _block_copy!(res, m1, m2)
    for i in CartesianIndices(m1)
        res[i] = m1[i]
    end

    size1 = CartesianIndex(size(m1)...)
    for i in CartesianIndices(m2)
        res[i + size1] = m2[i]
    end
end    

function blockdiagonal(m1::U, m2::V) where {T, U <:AbstractMatrix{T}, V <: AbstractMatrix{T}}
    M, N = size(m1) .+ size(m2)
    res = zeros(T, M, N)
    _block_copy!(res, m1, m2)
    res
end


function blockdiagonal(m1::U, m2::V) where {M1, M2, N1, N2, T, U <:StaticMatrix{M1, N1, T}, V <: StaticMatrix{M2, N2, T}}
    M, N = M1+M2, N1+N2
    res = @MMatrix zeros(T, M, N)
    _block_copy!(res, m1, m2)
    SizedMatrix{M, N, T}(res)
end

function blockdiagonal(mats::T) where T <: AbstractVector{Diagonal} 
    Diagonal(mapreduce(diag, vcat, mats))
end