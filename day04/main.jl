using DelimitedFiles

#####################
##  Parse data
concatCards, brokenHeader = readdlm("day04/input.txt", Int, header=true)

nb = parse.( Int, split(brokenHeader[1], ',') )
nextNb = Iterators.Stateful(nb)
nRow, nCol = 5, 5
cards = permutedims( reshape(concatCards, (nRow,:,nCol)), [1,3,2] )


#############################
##  Utilities 
isDrawn = falses(size(cards))

# Find winner(s) on the fly
hasWinRow() = any( all(isDrawn, dims=2), dims=1 )[:]
hasWinCol() = any( all(isDrawn, dims=1), dims=2 )[:]
flagWins()  = hasWinRow() .| hasWinCol()

drawNext() = ( isDrawn[cards .== popfirst!(nextNb)] .= true )
computeScore(idx, lastDrawn) = 
    sum(cards[:,:,idx] .* map(!,isDrawn[:,:,idx]) ) * lastDrawn


################################
##  Question 1
while !any( flagWins() )
    drawNext()
end

winnerBoard = findfirst( flagWins() )
result = computeScore(winnerBoard, nb[nextNb.taken])
println("Le score du bingo gagnant est $result")

##############################
## Question 2
flagLoss() = map(!, flagWins() )
loserBoard = 0
while any( flagLoss() )
    (sum( flagLoss() ) == 1 ) && 
        global loserBoard = findfirst( flagLoss()[:] )
    drawNext()
end

result = computeScore(loserBoard, nb[nextNb.taken])
println("Le score du bingo qui gagne le dernier est $result")