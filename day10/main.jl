using Statistics: median

fname = "day10/input.txt"

emptyChar = "."
foreignChar = "#"
del = Dict(")" => "(", "]" => "[", "}" => "{", ">" => "<")


function findLastOpener(chunk, l, r)
    i = findlast(∈(values(del)), chunk[l:r])
    isnothing(i) ? 0 : (i+l-1)
end

function killLastOpener!(chunk, l, r)
    i = findLastOpener(chunk, l, r)
    if i > 0 && del[chunk[r]] == chunk[i]
        chunk[r], chunk[i] = emptyChar, emptyChar
    else
        l = max(r-1, 1)
    end
    l
end

function collapseSyntax(line)
    l, chunk = 1, split(line, "")
    for (r, c) in enumerate(chunk)
        c ∈ keys(del) && ( l = killLastOpener!(chunk, l, r) )
    end
    prod(chunk)
end

simpleExpressions = collapseSyntax.( readlines(fname) )


############################
## Question 1
function firstCloser(line)
    i = findfirst(∈( keys(del) ), split(line, ""))
    isnothing(i) ? emptyChar : split(line,"")[i]
end
corruptVal = Dict(")" => 3, "]" => 57, "}" => 1197, ">" => 25137)
corruptedScore(exp) = get(corruptVal, firstCloser(exp), 0)


result = sum( corruptedScore.(simpleExpressions) )
println("Le score total des expressions corrompues est $result")


###########################
## Question 2
isIncomplete(exp) = ( firstCloser(exp) == emptyChar )

incompVal = Dict("(" => 1, "[" => 2, "{" => 3, "<" => 4)
incompleteScore(exp) = 
    reduce(
        (score,char) -> 5*score + incompVal[char],
        reverse( filter(!=(emptyChar), split(exp, "") ) ),
        init=0
    )

incompleteExpressions = filter(isIncomplete, simpleExpressions)
result = floor(Int, median( incompleteScore.( incompleteExpressions ) ))
println("Le score médian des expressions incomplètes est $result")