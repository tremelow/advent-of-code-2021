flines = readlines("day14/input.txt")

###########################
## Polymer chain
initChain = split(flines[1], "")
initPairs = initChain[1:end-1] .* initChain[2:end]

function updateFreq!(pairFreq, pair, incr=1)
    get!(pairFreq, pair, 0)
    pairFreq[pair] += incr
end

pairFreq = Dict{String,Int}()
for pair in initPairs
    updateFreq!(pairFreq, pair)
end


################################
## Update polymer chain

rules = Dict( 
    string(r[1]) => first(r[2]) 
    for r in split.(flines[3:end], " -> ") 
)

function updateAllFreq!(pairFreq)
    for (pair, freq) in copy(pairFreq)
        if !isempty( get(rules, pair, "") )
            toInsert = rules[pair]
            updateFreq!(pairFreq, pair[1]*toInsert, freq)
            updateFreq!(pairFreq, toInsert*pair[2], freq)
            updateFreq!(pairFreq, pair, -freq)
        end
    end
    nothing
end

function getIndivFreq(pairFreq, lastChar)
    allChar = unique(prod(keys(pairFreq)))
    indivFreq = Dict(
        c => sum( 
            (pair[1] == c ? freq : 0) 
            for (pair,freq) in pairFreq 
        )
        for c in allChar
    )

    get!(indivFreq, lastChar, 0)
    indivFreq[lastChar] += 1

    indivFreq
end

####################################
## Question 1
for _ in 1:10
    updateAllFreq!(pairFreq)
end

indivFreq = getIndivFreq(pairFreq, first(initChain[end]))
result = maximum(values(indivFreq)) - minimum(values(indivFreq))
println("Après 10 étapes, la quantité demandée vaut $result")


####################################
## Question 2
for _ in 11:40
    updateAllFreq!(pairFreq)
end

indivFreq = getIndivFreq(pairFreq, first(initChain[end]))
result = maximum(values(indivFreq)) - minimum(values(indivFreq))
println("Après 40 étapes, la quantité demandée vaut $result")