using CircularArrays

file = "day06/input.txt"

mutable struct PopulationState
    pop :: CircularVector
    offset :: Int

    function PopulationState(fname) 
        fish = parse.( Int, split(readline(fname), ',') )
        pop = CircularVector( [count(==(i), fish) for i ∈ [1:9 ; 0] ] )
        new(pop, 0)
    end
end

function simDay!(PS)
    day = PS.offset + 1
    PS.offset = day
    PS.pop[day+8] += PS.pop[day-1]
    PS.pop[day+6] += PS.pop[day-1]
    PS.pop[day-1]  = 0
    nothing
end

♓ = PopulationState(file)

## Question 1
nbDays = 80
for _ in 1 : nbDays
    simDay!(♓)
end

result = sum(♓.pop)
println("Nombre de poissons après $nbDays jours : $result")

## Question 2
nbDays2 = 256 
for _ in nbDays+1 : nbDays2
    simDay!(♓)
end
result = sum(♓.pop)
println("Nombre de poissons après $nbDays2 jours : $result")
