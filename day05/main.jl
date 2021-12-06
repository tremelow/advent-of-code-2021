using DelimitedFiles
using OffsetArrays

## Parsing
function toTuple(vecCoords)
    intMat = parse.( Int, hcat( split.(vecCoords, ',')... ) )
    Tuple.( reverse.( eachcol(intMat) ) )
end
data = readdlm("day05/input.txt", String)
fstIndices, scdIndices = toTuple(data[:,1]), toTuple(data[:,3])

# Create iterators from index1 to index2 (for each coordinate)
function fromTo(idx1, idx2)
    aux = (a,b) -> a : (a < b ? 1 : -1) : b
    ( aux(idx1[1],idx2[1]) , aux(idx1[2],idx2[2]) )
end

# Initialise danger matrix, with indices starting at 0
lastIdx = maximum( CartesianIndex.( vcat(fstIndices,scdIndices) ) )
dangerRating = OffsetMatrix( zeros(Int, Tuple(lastIdx).+1), -1, -1)


####################################
## Question 1
isLine(idx1, idx2) = (0 ∈ (idx1 .- idx2) )
for (idx1,idx2) in zip(fstIndices, scdIndices)
    if isLine(idx1,idx2)
        dangerRating[fromTo(idx1,idx2)...] .+= 1
    end
end

result = sum( dangerRating .> 1 )
println("Le nombre de zones dangereuses est $result")


##################################
## Question 2
isSquare(idx1, idx2) = ( abs(idx1[1] - idx2[1]) == abs(idx1[2] - idx2[2]) )
for (idx1,idx2) in zip(fstIndices, scdIndices)
    if isSquare(idx1, idx2)
        toVisit = CartesianIndex.( zip(fromTo(idx1,idx2)...) )
        dangerRating[toVisit] .+= 1
    end
end

result = sum( dangerRating .> 1 )
println("Oups avec les diagonales en fait c'est $result")