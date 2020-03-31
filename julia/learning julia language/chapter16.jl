# chapter 16

function myforeach(f, xs)
    for x in xs
    f(x)
    end
end

myforeach(println, ["a", "b", "c"])

myforeach([1, 2, 3]) do x
    println(x^x)
end


mutable struct School
    subject::Symbol
    nclasses::Int
    nstudents::Int # average no. of students per class    
end

dataset = [School(:math, 3, 30), School(:math, 5, 20), School(:science, 10, 5)]


function nmath(data)
    maths = filter(x -> x.subject === :math, data)
    students = map(x -> x.nclasses * x.nstudents, maths)
    reduce(+, students)
end

nmath(dataset)

data=dataset
maths = filter(x -> x.subject === :math, data)
students = map(x -> x.nclasses * x.nstudents, maths)
foldl(=>,students)
foldr(=>, students)