using DelimitedFiles
using Printf

# Load file
data = readdlm("day01/input.txt", Int)[:]

# Question 1
hasIncreased = diff(data) .> 0
@printf "Nombre d'incréments : %d\n" sum(hasIncreased)

# Question 2
smoothData = data[1:end-2] + data[2:end-1] + data[3:end]
hasIncreased = diff(smoothData) .> 0
@printf "Nombre d'incréments après lissage : %d\n" sum(hasIncreased)