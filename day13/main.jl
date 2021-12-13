using OffsetArrays
using Base.Iterators: take, drop
using DelimitedFiles

data = readdlm("day12/input.txt", ',')
lastDotIdx = findlast( 
    v -> typeof(v[1]) <: Int, 
    collect(eachrow(data)) 
)

posDots = [
    CartesianIndex(reverse(row .+ 1)...) 
    for row in take(eachrow(data), lastDotIdx)
]

struct Fold
    dim :: Int
    idx :: Int
    function Fold(inst)
        strDim, strIdx = split(inst, "=")
        dim = strDim[end] == 'x' ? 2 : 1
        idx = parse(Int, strIdx) + 1
        new(dim, idx)
    end
end
allFolds = [ Fold(row[1]) for row in drop(eachrow(data),lastDotIdx) ]

szPaper = collect( Tuple(maximum(posDots)) )
paper = falses( szPaper... )
paper[posDots] .= true

getActivePaper(paper, szPaper) = 
    paper[CartesianIndex(1,1):CartesianIndex(szPaper...)]

function applyFold!(paper, szPaper,fold)
    lenFold = szPaper[fold.dim] - fold.idx
    if fold.dim == 1
        paper[(fold.idx-lenFold):fold.idx, :] .|= reverse(paper[fold.idx:(fold.idx+lenFold),:], dims=1)
    else
        paper[:,(fold.idx-lenFold):fold.idx] .|= reverse(paper[:,fold.idx:(fold.idx+lenFold)], dims=2)
    end
    szPaper[fold.dim] -= lenFold + 1
end

applyFold!(paper, szPaper, allFolds[1])
result = sum( getActivePaper(paper, szPaper) )
println("Nombre de points visibles après le premier pliage : $result")


for fold in drop(allFolds, 1)
    applyFold!(paper, szPaper, fold)
end

finalPaper = getActivePaper(paper, szPaper)
toReadableString(x) = x ? "#" : "."
for row in eachrow(finalPaper)
    strRow = prod( toReadableString.(row) )
    println( strRow )
end