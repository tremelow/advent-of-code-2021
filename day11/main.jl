
strData = hcat( split.(readlines("day11/input.txt"),"")... )

CartIdx = CartesianIndex
adj = filter(!=(CartIdx(0,0)), CartIdx(-1,-1):CartIdx(1,1))

szArmy = size(strData)
octoArmy = zeros(Int, szArmy .+ 2)
octoArmy[2:end-1, 2:end-1] = parse.(Int, strData)
flashingOctopi = falses(size(octoArmy))

function resetEdges!(army)
    army[1,:] .= 0; army[end,:] .= 0; army[:,1] .= 0; army[:,end] .= 0
end


toFlash(army, flashed) = findall( (.! flashed) .& (army .> 9) )
function incrNeighbors(army, pos)
    for offset in adj
        army[pos + offset] += 1
    end
end
function stepOctopus!(army, flashed)
    @. flashed = false
    @. army += 1
    while !isempty( toFlash(army, flashed) )
        for pos in toFlash(army, flashed)
            flashed[pos] = true
            incrNeighbors(army, pos)
        end
    end
    resetEdges!(army)
    nothing
end


#####################################
## Question 1
nbFlashes = 0
for _ in 1:100
    stepOctopus!(octoArmy, flashingOctopi)
    global nbFlashes += sum(flashingOctopi)
    octoArmy[flashingOctopi] .= 0
end

println("Après 100 étapes, il y a eu un total de $nbFlashes flashes.")


#####################################
## Question 2
octoArmy[2:end-1, 2:end-1] = parse.(Int, strData) # reset army
@. flashingOctopi = false
step = 0
while !all(flashingOctopi[2:end-1, 2:end-1])
    stepOctopus!(octoArmy, flashingOctopi)
    octoArmy[flashingOctopi] .= 0
    global step += 1
end

println("Les poulpes flashent simultanément après $step étapes.")