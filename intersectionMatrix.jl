# import Pkg;
# Pkg.add("Hecke")

using Hecke
# Below: a is an integer s.t output = rank of Intersection matrix if a=0 
    #else returns the matrix as well as it's rank
function rkFQ(a) 
    K, w= cyclotomic_field(8::Int);
    Kx, (x0, x1, x2, x3) = PolynomialRing(K, ["x0", "x1", "x2", "x3"]);
    function list(w)
        A = [] #empty array that will later contain matrices for the lines on the Fermat Quartic
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
    # Generate matrices of the form (Lm | Ln) to find which lines intersect each other
    M = list(w);
    Im = Array{Int64}(undef, 48,48);  #Im is the intersection matrix  
    for i in 1:size(M)[1]
        for j in 1:size(M)[1]
            N = vcat(M[i], M[j]);
            if rank(N) == 2 # rank() = 2 -> self intersection of lines
                Im[i, j] = -2;
            elseif rank(N) == 3  # rank() = 3 -> the two lines intersect at a point
                Im[i, j] = 1;
            else  # rank() = 4 -> the lines don't intersect
                Im[i, j] = 0;
            end
        end
    end
    if a == 0
        result = rank(Im);   
    else a
        result = Im;
    end
    return result
end
