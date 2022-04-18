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
%builtins output

# Import the serialize_word() function.
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.alloc import alloc

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

func fill_algorithm{output_ptr : felt*}(
    y : felt, x : felt, target : felt, board : felt**, visited : Gem*, len : felt
) -> (gc : felt):
    alloc_locals
    let (flag) = contains(y, x, visited, len - 1)
    if flag == 1:
        return (len)
    end

    if board[y][x] == target:
        assert visited[len] = Gem(x=x, y=y)
         serialize_word(1)
        # serialize_word(y)
        # serialize_word(x)
        let (l2) = fill_algorithm(y, x + 1, target, board, visited, len + 1)
        let (l3) = fill_algorithm(y, x - 1, target, board, visited, l2)
        let (l4) = fill_algorithm(y - 1, x, target, board, visited, l3)
        let (l5) = fill_algorithm(y + 1, x, target, board, visited, l4)
        return (l5)
    end

    return (len)
end

func main{output_ptr : felt*}():
    let visited : Gem* = alloc()
    tempvar board : felt** = cast(new (
        cast(new (0, 0, 0, 0, 0, 0), felt*),
        cast(new (0, 0, 0, 0, 0, 0), felt*),
        cast(new (0, 0, 0, 0, 0, 0), felt*),
        cast(new (1, 1, 0, 1, 1, 1), felt*),
        cast(new (1, 1, 1, 1, 0, 0), felt*),
        cast(new (1, 1, 1, 1, 1, 0), felt*),
        cast(new (1, 0, 0, 1, 1, 1), felt*),
        cast(new (1, 1, 1, 1, 1, 1), felt*),
        cast(new (1, 1, 1, 1, 1, 1), felt*)), felt**)
    # serialize_word(board[8][0])
    let (count) = fill_algorithm(8, 1, 1, board, visited, 0)
    serialize_word(count)
    return ()
end

