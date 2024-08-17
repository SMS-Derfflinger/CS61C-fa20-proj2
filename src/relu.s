.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    li t0, 1
    bge a1, t0, loop_start # if a1 >= t0 then loop_start
    li a1, 78
    j exit2

loop_start:
    li t0, 0 # index of array

loop_continue:
    slli t1, t0, 2
    add t1, t1, a0 # t1 is the address of a[t0]
    lw t2, 0(t1) # t2 is the value of a[t0]
    bge t2, x0, loop_next # if t2 >= x0 then loop_next
    sw x0, 0(t1)

loop_next:
    addi t0, t0, 1
    blt t0, a1, loop_continue # if t0 < a1 then loop_continue

loop_end:

    # Epilogue
	ret
