@show 1 + 1

macro myshow(expression)
    quote
        value = $expression
        println($(Meta.quot(expression)), " = ", value)
        value
    end
end

x = @myshow 1+1
x


macro until(condition, expression)
    quote
        while !($condition)
            $expression
        end
    end |> esc
end

macro until(condition, expression)
    esc(quote
        while !($condition)
            $expression
        
        end
    end)
end


global i = 0 ;

@until i == 10 begin
    println(i)
    global i += 1
end

@until



macro until(condition, expression)
    quote
        while !($condition)
            $expression
        end
    end |> esc
end

@until i == 10 begin
    println(i)
    i += 1
end