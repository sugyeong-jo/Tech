#Chapter 17

function askname()
    print("Enter your name: ")
    readline()
end

askname()

function askname()
    print("Enter your name: ")
    chomp(readline())
end

askname()

readlines() # note Ctrl-D is pressed after the last line
A, B, C, D, E, F, G
H, I, J, K, LMNO, P
Q, R, S
T, U, V
W, X
Y, Z

chomp.(readlines())
A, B, C, D, E, F, G
H, I, J, K, LMNO, P
Q, R, S
T, U, V
W, X
Y, Z

function asknumber()
    print("Enter a number: ")
    parse(Float64, readline())
end

asknumber()


function askints()
    print("Enter some integers, separated by spaces: ")
    [parse(Int, x) for x in split(readline())]
end


open("./julia/learning julia language/myfile.txt") do f
    for (i, line) in enumerate(eachline(f))
        print("Line $i: $line")
    end
end

open(readlines, "./julia/learning julia language/myfile.txt")
open(read, "./julia/learning julia language/myfile.txt")

using DelimitedFiles
readdlm("./julia/learning julia language/file.csv",',',header=true)
