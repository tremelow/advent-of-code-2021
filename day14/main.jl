flines = readlines("day14/input.txt")

###########################
## Polymer chain

emptyChar = '_'
mutable struct Node
    label :: AbstractChar
    next  :: Node
    Node() = (x = new(); x.label = emptyChar; x.next = x)
    Node(label, next) = new(label, next)
end

function chainToString(chain)
    curNode, curString = chain, ""
    while curNode.label != emptyChar
        curString *= curNode.label
        curNode = curNode.next
    end
    curString
end

function buildChain(formula)
    chain = Node()
    for c in reverse(formula)
        chain = Node(c, chain)
    end
    return chain
end
chain = buildChain(flines[1])


################################
## Update polymer chain

rules = Dict( 
    string(r[1]) => first(r[2]) 
    for r in split.(flines[3:end], " -> ") 
)

function updateChain!(curNode)
    toInsert = get(rules, curNode.label * curNode.next.label, emptyChar)
    nextNode = curNode.next
    (toInsert != emptyChar) &&
        ( curNode.next = Node(toInsert, nextNode) )
    (curNode.label != emptyChar) &&
        updateChain!(nextNode)
end


for _ in 1:40
    updateChain!(chain)
end

strChain = chainToString(chain)
freqLabel = Dict(a => count(==(a), strChain) for a in unique(strChain) )

result = maximum(values(freqLabel)) - minimum(values(freqLabel))
println("La quantité recherchée est $result")