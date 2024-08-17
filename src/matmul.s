.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, exit72 # if a1 < t0 then exit72
    blt a2, t0, exit72 # if a2 < t0 then exit72

    blt a4, t0, exit73 # if a4 < t0 then exit73
    blt a5, t0, exit73 # if a5 < t0 then exit73

    bne a2, a4, exit74 # if a2 != a4 then exit74

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)

outer_loop_start:
    li t0, 0 # int i = 0
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

outer_loop_continue:
    mul t2, t0, s2
    slli t2, t2, 2
    add t3, s0, t2 # the address of m0's row

inner_loop_start:
    li t1, 0 # int j = 0

inner_loop_continue:

    slli t2, t1, 2
    add t4, s3, t2 # the address of m1's col

    addi sp, sp, -28
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    sw t4, 20(sp)
    sw t5, 24(sp)

    mv a0, t3 # the parameters of dot function
    mv a1, t4
    mv a2, s2
    li a3, 1
    mv a4, s5

    jal dot

    sw a0, 0(s6)
    addi s6, s6, 4

    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    lw t4, 20(sp)
    lw t5, 24(sp)
    addi sp, sp, 28

    addi t1, t1, 1 # j++
    blt t1, s5, inner_loop_continue # if t1 < s5 then inner_loop_continue

inner_loop_end:

    addi t0, t0, 1
    blt t0, s1, outer_loop_continue

outer_loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    addi sp, sp, 28

    ret

exit72:
    li a1, 72
    j exit2

exit73:
    li a1, 73
    j exit2

exit74:
    li a1, 74
    j exit2
