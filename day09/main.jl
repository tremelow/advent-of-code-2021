using CircularArrays

# heightmap
dataH = parse.(Int, hcat( 
    split.(readlines("day09/input.txt"), "")... ) )
dataH = hcat( [v for v in eachrow(dataH)]... )
@. dataH += 1 # convert to risk score

maxH = maximum(dataH)
H = CircularArray( fill(maxH, size(dataH) .+ 1) )
H[2:end, 2:end] .= dataH

nbr = [CartesianIndex(1,0), CartesianIndex(0,1), 
    CartesianIndex(-1,0), CartesianIndex(0,-1)]


##################################
# Question 1
isMin(idx) = all(H[idx] < H[idx + n] for n in nbr)
lowPoints = filter(isMin, eachindex(H))
result = sum( H[lowPoints] )
println("La somme des risques minimaux est $result")


##################################
# Question 2
sizeBasin = zeros(Int, size(H))
inBasin = CircularArray(falses(size(H)))
validNbr(idx, n) = (!inBasin[idx+n] & (H[idx+n] < maxH))
function addNbr(idx)
    inBasin[idx] = true
    for n in nbr
        validNbr(idx, n) && addNbr(idx+n)
    end
end

for idx in lowPoints
    addNbr(idx)
    sizeBasin[idx] = sum(inBasin)
    @. inBasin = false
end

result = prod(partialsort(sizeBasin[lowPoints], 1:3, rev=true))
println("Le produit des tailles des bassins les plus grands vaut $result")