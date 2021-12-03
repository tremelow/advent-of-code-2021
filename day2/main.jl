using DelimitedFiles

# Load data
data = readdlm("day2/input.txt", ' ')
strDirections = String.( data[:,1] )
speed = Int.( data[:,2] )


##########################################
##  Question 1

# Moves
translateDirections = Dict(
    "forward"   => [1, 0],
    "up"        => [0, -1],
    "down"      => [0, 1]
)
cardDirections = replace(strDirections, translateDirections...)
moves = cardDirections .* speed

# Final position
result = prod(sum(moves))
println("Produit des coordonnées finales, méthode 1 : $result")


###########################################
##  Question 2
translateAim = Dict("up" => -1, "down" => 1, "forward" => 0)
aimChanges = replace(strDirections, translateAim...) .* speed
aim = cumsum(aimChanges)
hChanges = (aimChanges .== 0) .* speed
vChanges = (aimChanges .== 0) .* aim .* speed

# Final position
result = sum(hChanges) * sum(vChanges)
println("Produit des coordonnées finales, méthode 2 : $result")