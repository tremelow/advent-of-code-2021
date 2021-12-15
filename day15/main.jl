using Graphs, SimpleWeightedGraphs

fname = "day15/input.txt"

riskMap = parse.(Int, hcat( split.(readlines(fname),"")... ) )
# riskMap = hcat( riskMap, riskMap )
xMax, yMax = size(riskMap)

########################
## Convert to graph
graphRisk = SimpleWeightedDiGraph(xMax*yMax)
for ij in LinearIndices(riskMap)
    i,j = mod1(ij, xMax), (ij-1)÷xMax + 1
    north, south = ij-1, ij+1
    west, east = ij-xMax, ij+xMax
    ( i != 1 ) && add_edge!(graphRisk, north, ij, riskMap[ij])
    ( j != 1 ) && add_edge!(graphRisk, west, ij, riskMap[ij])
    ( i != xMax ) && add_edge!(graphRisk, south, ij, riskMap[ij])
    ( j != yMax ) && add_edge!(graphRisk, east, ij, riskMap[ij])
end

# Get shortest path
shortestPath = enumerate_paths(
    dijkstra_shortest_paths(graphRisk, 1), xMax*yMax
)
result = sum(riskMap[shortestPath]) - riskMap[1]
println(result)