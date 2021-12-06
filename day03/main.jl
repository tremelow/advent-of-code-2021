using DelimitedFiles

data = readdlm("day03/input.txt", String)[:]
bits = ( hcat(split.(data, "")...) .== "1" )
bitSize, N = size(bits)

bitsToInt = arr ->  reverse!(arr[:]).chunks[1]

##############################################
##  Question 1
gammaBits   = (sum(bits, dims=2) .> N/2)
epsilonBits = broadcast(!, gammaBits)
gamma, epsilon = bitsToInt(gammaBits), bitsToInt(epsilonBits)

result = gamma * epsilon
println("Produit des nombres γ et ε : $result")



################################################
##  Question 2

function getIndices(comp)
    iBit, validIndices = 1, trues(N)
    while sum(validIndices) > 1
        # bit de comparaison
        compBit = comp.(
            sum(bits[iBit, validIndices]) , sum(validIndices)/2 )
        # filtrage des bits invalides
        @. validIndices[ bits[iBit, :] != compBit ] = false
        iBit += 1
    end
    validIndices
end

oxBits, coBits = bits[:, getIndices(>=)], bits[:, getIndices(<)]
oxNumber, coNumber = bitsToInt(oxBits), bitsToInt(coBits)

result = oxNumber * coNumber
println("Life support rating : $result")