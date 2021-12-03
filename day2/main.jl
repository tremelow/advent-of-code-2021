using DelimitedFiles

# Load data
data = readdlm("day2/input.txt", ' ')
strDirections = String.( data[:,1] )
speed = Int.( data[:,2] )

##########################################
##  Question 1
vTranslate = Dict("up" => -1, "down" => 1, "forward" => 0)
vMoves = replace(strDirections, vTranslate...) .* speed
hMoves = (strDirections .== "forward") .* speed

result = sum(vMoves) * sum(hMoves)
println("Produit des coordonnées finales, méthode 1 : $result")


###########################################
##  Question 2
translateAim = Dict("up" => -1, "down" => 1, "forward" => 0)
aimChanges = replace(strDirections, translateAim...) .* speed
aim = cumsum(aimChanges)
hChanges = (strDirections .== "forward") .* speed
vChanges = hChanges .* aim

result = sum(hChanges) * sum(vChanges)
println("Produit des coordonnées finales, méthode 2 : $result")