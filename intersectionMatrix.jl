# import Pkg;
# Pkg.add("Hecke")

using Printf
using Hecke

function rkFQ(a)
    K, w= cyclotomic_field(8::Int);
    Kx, (x0, x1, x2, x3) = PolynomialRing(K, ["x0", "x1", "x2", "x3"]);
    function list(w)
        A = [] #empty array
        for j in [1, 3, 5, 7]
            for k in [1, 3, 5, 7]
                # Li are matrices with specific entries from the coefficient of the defining polynomial equations
                L1 = matrix(K, [1 w^j 0 0; 0 0 1 w^k]); # L1[j, k] = V(x0 + w^j * x1 , x2 + w^k * x3);
                L2 = matrix(K, [1 0 w^j 0; 0 1 0 w^k]); #L2[j, k] = V(x0 + w^j * x2, x1 + w^k * x3);
                L3 = matrix(K, [1 0 0 w^j; 0 1 w^k 0]); #L3[j, k] = V(x0 + w^j * x3, x1 + w^k * x2);
                A = push!(A, L1, L2, L3);
            end
        end
        return A;
    end
    #n = size(list(w)); #size of the array A
    # Generate matrices of the form (Lm | Ln)
    # Q = vcat(M, N)
    M = list(w);
    N = Array{Int64}(undef, 4,4);
    Im = Array{Int64}(undef, 48,48);    
    for i in 1:size(M)[1]
        for j in 1:size(M)[1]
            N = vcat(M[i], M[j]);
            #rk = rank(N);
            if rank(N) == 2  # if the rank of the matrix is 2 then save -2 as the (m,n)-th entry of a matrix M
                Im[i, j] = -2;
            elseif rank(N) == 3  # if the rank of the matrix is 3 then save 1 as the (m,n)-th entry of a matrix M
                Im[i, j] = 1;
            else  # if the rank of the matrix is 4 then save 0 as the (m,n)-th entry of a matrix M
                Im[i, j] = 0;
            end
        end
    end
    rk = println(rank(Im));
    if a == 0
        result = rk;   
    else
        result = Im;
    end
    return result
end
