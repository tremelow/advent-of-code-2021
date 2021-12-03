using DelimitedFiles

data = readdlm("day3/input.txt", String)[:]
strBits = hcat(split.(data, "")...) 
bits = (strBits .== "1")

bitSize, N = size(bits)
nbOnes = sum(bits, dims=2)

gammaBits   = (nbOnes .> N/2)
epsilonBits = broadcast(!, gammaBits)


##############################################
##  Question 1
function bitsToInt(arr)
    # Peu efficient mais code compact uwu
    str = "0b" * prod(broadcast(b -> b ? "1" : "0", arr))
    parse(Int, str)
end

γ = bitsToInt(gammaBits)
ε = bitsToInt(epsilonBits)

result = γ * ε
println("Produit des nombres γ et ε : $result")



################################################
##  Question 2

function getIndices(comp)
    iBit = 1
    validIndices = trues(N)
    while sum(validIndices) > 1
        newN = sum(validIndices)
        # bit de comparaison
        compBit = comp.( sum(bits[iBit, validIndices]) , newN/2 )
        validIndices .&= ( bits[iBit, :] .== compBit )
        iBit += 1
    end

    validIndices
end


oxBits, coBits = bits[:, getIndices(>=)], bits[:, getIndices(<)]
oxNumber, coNumber = bitsToInt(oxBits), bitsToInt(coBits)
result = oxNumber * coNumber
println("Life support rating : $result")