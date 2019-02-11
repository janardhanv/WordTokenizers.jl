# A simple reversible tokenizer

MERGESYMBOL = '~'

function is_weird(c::AbstractChar)
    return !(isletter(c) ||isnumeric(c) || isspace(c))
end


function rev_tokenize(instring::AbstractString)
    ans = IOBuffer()
    for ind in eachindex(instring)
        c = instring[ind]
        c_p = ind > 1 ? instring[ind-1] : c
        c_n = ind < length(instring) ? instring[ind+1] : c
        
        if !is_weird(c)
            write(ans,c)
        else
            if !isspace(c_p)
                write(ans," ",MERGESYMBOL)
            end
            write(ans,c)
            if !isspace(c_n) && !is_weird(c_n)
                write(ans,MERGESYMBOL," ")
            end
        end
       
    end
    return split(String(take!(ans)))
end


function rev_detokenizer(instring::Array{AbstractString})
    ind = 1
    ans = IOBuffer()
    instring = join(instring," ")
    while ind <= length(instring)
        c = instring[ind]
        c_p = ind > 1 ? instring[ind-1] : c
        c_n = ind < length(instring) ? instring[ind+1] : c
        c_pp = ind > 2 ? instring[ind-2] : c
        c_nn = ind < length(instring) - 1 ? instring[ind+2] : c
        
        if c * c_n == ' ' * MERGESYMBOL && is_weird(c_nn)
            ind += 2
        elseif is_weird(c) && c_n * c_nn == MERGESYMBOL * ' '
            write(ans,c)
            ind += 3
        else
            write(ans,c)
            ind += 1
        end
    end
    return String(take!(ans))
end
