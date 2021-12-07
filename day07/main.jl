initPos = parse.( Int, split(readline("day07/input.txt"), ',') )
allPositions = minimum(initPos) : maximum(initPos)

getDist(h) = abs.( initPos .- h )

## Question 1
getLinCost(h) = sum( getDist(h) )
result = minimum(getLinCost, allPositions )
println("Avec un calcul linéaire, le cout minimal est $result")

## Question 2
getQuadCost(h) = sum( getDist(h) .* (getDist(h).+1) ) ÷ 2
result = minimum( getQuadCost, allPositions )
println("Avec un calcul quadratique, le cout minimal est $result")