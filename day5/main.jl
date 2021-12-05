using DelimitedFiles
using OffsetArrays
using LinearAlgebra: diag
using Base.Iterators: product

data = readdlm("day5/input.txt", String)


## Parsing
function toTuple(strVec)
    intMat = parse.( Int, hcat( split.(strVec, ',')... ) )
    Tuple.( reverse.( eachcol(intMat) ) )
end
fstIndices = toTuple(data[:,1])
scdIndices = toTuple(data[:,3])

# Create iterators from index1 to index2 (for each coordinate)
function fromTo(idx1, idx2)
    aux = (a,b) -> a : (a < b ? 1 : -1) : b
    ( aux(idx1[1],idx2[1]) , aux(idx1[2],idx2[2]) )
end

# Initialise danger matrix, with indices starting at 0
southEast = maximum( CartesianIndex.( vcat(fstIndices,scdIndices) ) )
nRow, nCol = southEast[1]+1, southEast[2]+1
dangerRating = OffsetMatrix( zeros(Int, nRow, nCol), -1, -1)


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
isSqr(idx1, idx2) = ( abs(idx1[1] - idx2[1]) == abs(idx1[2] - idx2[2]) )
for (idx1,idx2) in zip(fstIndices, scdIndices)
    if isSqr(idx1, idx2)
        toVisit = CartesianIndex.( zip(fromTo(idx1,idx2)...) )
        dangerRating[toVisit] .+= 1
    end
end
result = sum( dangerRating .> 1 )
println("Oups avec les diagonales en fait c'est $result")