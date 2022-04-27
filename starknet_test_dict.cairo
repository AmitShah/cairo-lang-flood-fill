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
%lang starknet
%builtins range_check

# Import the serialize_word() function.
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize

from starkware.cairo.common.dict import dict_new, dict_write, dict_update, dict_squash, dict_read
from starkware.cairo.common.dict_access import DictAccess

struct Gem:
    member x : felt
    member y : felt
end

func check_key{dict_ptr : DictAccess*}(a : felt, b : felt) -> (rv : felt, d : DictAccess*):
    alloc_locals
    tempvar key = a * b

    let (v) = dict_read{dict_ptr=dict_ptr}(key=key)
    if v == 0:
        return (0, dict_ptr)
    end
    return (1, dict_ptr)
end

func gravity(column_len : felt, column : felt*, new_column_len : felt, new_column : felt*) -> (
    c : felt
):
    if column_len == -1:
        return (new_column_len)
    end
    if column[column_len] == 1:
        assert new_column[new_column_len] = 1
        return gravity(column_len - 1, column, new_column_len - 1, new_column)
    end
    return gravity(column_len - 1, column, new_column_len, new_column)
end

func fill(num_fill : felt, val : felt, column : felt*):
    if num_fill == -1:
        return ()
    end
    assert column[num_fill] = val
    return fill(num_fill - 1, val, column)
end

func fill_algorithm(
    y : felt, x : felt, target : felt, board : felt**, x_dict : DictAccess*, count : felt
) -> (xd : DictAccess*, c : felt):
    alloc_locals
    # let (flag) = contains(y, x, visited, len - 1)
    # let (f2,d1) = check_key{dict_ptr=my_dict}(x,y)
    # serialize_word(d)
    # if flag == 1:
    # keys cannot be negative !
    let bounds = (x + 1) * (x - 6) * (y + 1) * (y - 9)
    if bounds == 0:
        return (x_dict, count)
    end
    let key = x * 3 + y * 7
    let (v1) = dict_read{dict_ptr=x_dict}(key=key)
    if v1 == 1:
        return (x_dict, count)
    end
    dict_write{dict_ptr=x_dict}(key=key, new_value=1)
    if board[y][x] == target:
        let c1 = count + 1
        # assert visited[len] = Gem(x=x, y=y)
        # serialize_word(99999)
        # serialize_word(y)
        # serialize_word(x)
        let (x2, c2) = fill_algorithm(y, x + 1, target, board, x_dict, c1)
        let (x3, c3) = fill_algorithm(y, x - 1, target, board, x2, c2)
        let (x4, c4) = fill_algorithm(y - 1, x, target, board, x3, c3)
        let (x5, c5) = fill_algorithm(y + 1, x, target, board, x4, c4)
        return (x5, c5)
    end

    return (x_dict, count)
end

@view
func run_flood_fill{range_check_ptr}() -> (count : felt, nc_len : felt, nc : felt*):
    alloc_locals
    let (local x_dict) = default_dict_new(default_value=0)
    # let my_dict = dict_start
    # dict_write{dict_ptr=my_dict}(key=0, new_value=8)
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
    let (xd, c) = fill_algorithm(8, 1, 1, board, x_dict, 0)
    default_dict_finalize(dict_accesses_start=x_dict, dict_accesses_end=xd, default_value=0)
    tempvar column = cast(new (0, 1, 0, 1, 1, 0, 1, 0, 0), felt*)
    let (new_column) = alloc()
    let (f) = gravity(8, column, 8, new_column)
    fill(f, 0, new_column)

    # serialize_word(888)

    return (count=c, nc_len=8, nc=new_column)
end
