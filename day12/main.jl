data = split.(readlines("day12/input-test1.txt"), "-")

nodes = String.(unique(vcat(data...)))
links = Dict(n => String[] for n in nodes)
for path in data
    l, r = path
    push!(links[l], r )
    push!(links[r], l )
end
isVisited = Dict(n => false for n in nodes)
isBig(n) = isuppercase( n[1] )

function exploreNext(isVisited, node)
    nothing
end