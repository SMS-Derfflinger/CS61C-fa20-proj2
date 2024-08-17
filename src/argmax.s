.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    li t0, 1
    bge a1, t0, loop_start # if a1 >= t0 then loop_start
    li a1, 77
    j exit2

loop_start:
    li t0, 0 # index of array
    li t3, 0 # the first index of the largest element

loop_continue:
    slli t1, t0, 2
    add t1, t1, a0 # t1 is the address of a[t0]
    lw t2, 0(t1) # t2 is the value of a[t0]

    slli t4, t3, 2
    add t4, t4, a0
    lw t5, 0(t4)

    bge t5, t2, loop_next # if t2 >= x0 then loop_next
    mv  t3, t0 # t3 = t0

loop_next:
    addi t0, t0, 1
    blt t0, a1, loop_continue # if t0 < a1 then loop_continue

loop_end:


    # Epilogue
    mv a0, t3 # a0 = t3
    ret
