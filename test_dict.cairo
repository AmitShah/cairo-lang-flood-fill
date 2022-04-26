# Welcome to the Cairo playground!
#
# The purpose of this site is to allow you to play with the Cairo language
# without downloading and installing the toolchain on your computer.
# If you want to install it, you can read the instructions [here](https://www.cairo-lang.org/docs/quickstart.html).
#
# On the top-right corner, you should see the "Challenges" button.
# The challenges provide hands-on exercises that teach you how to write code in Cairo.
# For more information, you can read the two tutorials: "Hello Cairo" and
# "How Cairo Works", which can be found [here](https://www.cairo-lang.org/docs/).
#
# So, let's get started!
# 1. Click on the "Debug" button to run the code below.
# 2. You should see the output of the run in the "output" panel below.
# 3. After clicking "Debug", the playground enters "debug" mode,
#    where you can follow the execution of the program.
# 4. Click on the buttons with the right and left arrows located at the
#    top-right corner of the "Memory" panel to respectively advance or rewind
#    the steps of the program execution.
#    You may also press 's' to move forward and 'S' (shift+s) to move backward.
# 5. Take a look at the "Watch" panel (located at the bottom right),
#    where you can see the values of the variables in the current context.
# 6. The "Memory" panel enables you to examine the lower-level details of
#    the run.
# 7. Find the value of output_ptr in the "Watch" panel. This value is a pointer
#    to the memory. Find the memory row with that address and verify that you
#    see the 3 output values in the right column.
#
# See you in the next challenge!

# Use the output builtin.
%builtins output range_check

# Import the serialize_word() function.
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.default_dict import (
    default_dict_new,
    default_dict_finalize,
)

from starkware.cairo.common.dict import (
    dict_new,
    dict_write,
    dict_update,
    dict_squash,
    dict_read
)
from starkware.cairo.common.dict_access import DictAccess

struct Gem:
    member x : felt
    member y : felt
end

func contains(y : felt, x : felt, visited : Gem*, len : felt) -> (rv : felt):
    
    if len == -1:
        return (0)
    end
    tempvar bounds = (x + 1) * (x - 6) * (y + 1 ) * (y - 9)
    if bounds == 0:
        return(1)
    end
    tempvar flagx = (x - visited[len].x)
    tempvar flagy = (y - visited[len].y)
    if flagx == 0:
        if flagy == 0:
            return (1)
        end
    end
    return contains(y, x, visited, len - 1)
end

func check_key{output_ptr:felt*, dict_ptr : DictAccess*}(a : felt, b : felt) -> (rv:felt, d: DictAccess*):
    alloc_locals
    tempvar key = a*b
    
    let (v) = dict_read{dict_ptr=dict_ptr}(key=key)
    if v == 0:
        serialize_word(66)
        return(0,dict_ptr)
    end
    serialize_word(99)
    return (1,dict_ptr)
end

func fill_algorithm{output_ptr : felt*}(
    y : felt, x : felt, target : felt, board : felt**, x_dict: DictAccess*) -> (xd: DictAccess*):
    alloc_locals
    #let (flag) = contains(y, x, visited, len - 1)
    #let (f2,d1) = check_key{dict_ptr=my_dict}(x,y)
    #serialize_word(d)
    #if flag == 1:
    #keys cannot be negative !
    let bounds = (x + 1) * (x - 6) * (y + 1 ) * (y - 9)
    if bounds == 0:
        return(x_dict)
    end
    let key = x*3 + y*7
    let (v1) = dict_read{dict_ptr=x_dict}(key=key)
    if v1 == 1 :   
        return (x_dict)
    end   
    dict_write{dict_ptr=x_dict}(key=key, new_value=1)   
    if board[y][x] == target:
        #assert visited[len] = Gem(x=x, y=y)
        serialize_word(99999)
        # serialize_word(y)
        # serialize_word(x)
        let (x2) = fill_algorithm(y, x + 1, target, board, x_dict)
        let (x3) = fill_algorithm(y, x - 1, target, board, x2)
        let (x4) = fill_algorithm(y - 1, x, target, board, x3)
        let (x5) = fill_algorithm(y + 1, x, target, board, x4)
        return (x5)
    end

    return (x_dict)
end

func main{output_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (local x_dict) = default_dict_new(default_value=0)
    let (local y_dict) = default_dict_new(default_value=0)
     default_dict_finalize(
        dict_accesses_start=x_dict,
        dict_accesses_end=x_dict,
        default_value=0)
    default_dict_finalize(
        dict_accesses_start=y_dict,
        dict_accesses_end=y_dict,
        default_value=0)
    #let my_dict = dict_start
    #dict_write{dict_ptr=my_dict}(key=0, new_value=8)
    tempvar board : felt** = cast(new (
        cast(new (0, 0, 0, 0, 0, 0), felt*),
        cast(new (0, 0, 0, 0, 0, 0), felt*),
        cast(new (0, 0, 0, 0, 0, 0), felt*),
        cast(new (1, 1, 0, 1, 1, 1), felt*),
        cast(new (1, 1, 1, 1, 0, 0), felt*),
        cast(new (1, 1, 1, 1, 1, 0), felt*),
        cast(new (0, 0, 0, 1, 0, 0), felt*),
        cast(new (0, 0, 0, 1, 1, 1), felt*),
        cast(new (1, 1, 1, 1, 1, 1), felt*)), felt**)
    # serialize_word(board[8][0])
    let (xd) = fill_algorithm(8, 1, 1, board, x_dict )
    serialize_word(888)
   
    return ()
end

