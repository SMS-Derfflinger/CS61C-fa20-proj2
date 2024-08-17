.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    li t0, 1
    blt a2, t0, exit75 # if a2 < 1 then exit75
    blt a3, t0, exit76 # if a3 < 1 then exit76
    blt a4, t0, exit76 # if a4 < 1 then exit76

    addi sp, sp, -4
    sw s0, 0(sp)

loop_start:

    li t0, 0 # index of array v0
    li t3, 0 # index of array v1
    li s0, 0 # the dot product of v0 and v1

loop_continue:

    slli t1, t0, 2
    add t1, t1, a0 # t1 is the address of v0[t0]
    lw t2, 0(t1) # t2 is the value of v0[t0]

    slli t4, t3, 2
    add t4, t4, a1 # t4 is the address of v1[t3]
    lw t5, 0(t4) # t5 is the value of v1[t3]

    mul t6, t2, t5 # t6 is the value of v0[t0] * v1[t3]
    add s0, s0, t6

    add t0, t0, a3
    add t3, t3, a4
    bge t0, a2, loop_end # if t0 >= a2 then loop_end
    bge t3, a2, loop_end # if t3 >= a2 then loop_end

    j loop_continue

loop_end:


    # Epilogue
    mv a0, s0
    lw s0, 0(sp)
    addi sp, sp, 4
    ret

exit75:
    li a1, 75
    j exit2

exit76:
    li a1, 76
    j exit2
