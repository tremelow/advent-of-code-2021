using Combinatorics: powerset

data = hcat( split.( readlines("day08/input-test.txt"), " | ")... )

inputs = hcat( split.(data[1,:], " ")... ) 
outputs = hcat( split.(data[2,:], " ")... )

####################################
## Question 1
lengthToNumber = Dict(2 => 1, 3 => 7, 4 => 4, 7 => 8)
isImmediate(out) = ( length(out) ∈ keys(lengthToNumber) )
result = length( filter(isImmediate, outputs ) )
println("Somme des nombres immédiatement reconnaissables : $result")

####################################
## Question 2
const \ = setdiff
# (C|F)     from 1
# (B|D)     from 4
# (A)       from 7
# (G)       from 9
# (E)       from 8
# (F)       from 5
# (D)       from 3
# (B)       from 4
# (C)       from 1
# => make automatic
decΩ = Set([:A, :B, :C, :D, :E, :F, :G])
S = Dict(
    0 => Set([:A, :B, :C, :E, :F, :G]),
    1 => Set([:C, :F]),
    2 => Set([:A, :C, :D, :E, :G]),
    3 => Set([:A, :C, :D, :F, :G]),
    4 => Set([:B, :C, :D, :F]),
    5 => Set([:A, :B, :D, :F, :G]),
    6 => Set([:A, :B, :D, :E, :F, :G]),
    7 => Set([:A, :C, :F]),
    8 => Set([:A, :B, :C, :D, :E, :F, :G]),
    9 => Set([:A, :B, :C, :D, :F, :G]),
)
lenToSet = Dict( 
    len => union( filter(s -> (length(s) == len), collect(values(S)))... )
    for len in unique(length.(values(S)))
)
encΩ = string.(split("abcdefg", ""))

words = string.(split("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab", " ") )
wordToSet(w) = Set{String}(split(w, "") )

# Initialisation
encToDec = Dict()
for w in powerset( split("abcdefg", "") )
    encToDec[string.(w)] = copy(decΩ)
end
encToDec[String[]] = Set{Symbol}()

isValid(kv) = ( length(kv[1]) == length(kv[2]) )

for w in words
    encSet = string.( sort(split(w,"")) )
    decSet = copy( lenToSet[length(w)] )
    encToDec[ encSet ] = decSet
    isValid( (encSet, decSet) ) && 
        ( encToDec[ encΩ \ encSet ] = ( decΩ \ decSet ) )
end


for _ in 1:10
    for (kv1,kv2) in Iterators.product(copy(encToDec), copy(encToDec))
        enc1, dec1 = kv1
        enc2, dec2 = kv2
        encSet, decSet = enc1 ∩ enc2, dec1 ∩ dec2
        intersect!(encToDec[encSet], decSet)
        isValid( (encSet, decSet) ) && 
            ( encToDec[ encΩ \ encSet ] = ( decΩ \ decSet ) )
    end
end

# display(encToDec)