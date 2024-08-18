.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    mv a1, s0
    mv a2, x0
    jal fopen
    mv s4, a0 # file descriptor
    li t0, -1
    beq a0, t0, exit90 # if a0 == t0 then exit90

    mv a1, s4
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, exit91 # if a0 != t0 then exit91

    mv a1, s4
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, exit91 # if a0 != t0 then exit91

    lw t0, 0(s1)
    lw t1, 0(s2)
    mul s5, t0, t1 # size of array
    slli t0, s5, 2 # bytes' number of array
    mv a0, t0
    jal malloc
    beq a0, x0, exit88 # if a0 == x0 then exit88
    mv s3, a0 # the pointer to the new matrix in memory

loop_start:
    li t0, 0 # int i = 0

loop_continue:
    slli t1, t0, 2
    add t2, t1, s3 # the address

    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)

    mv a1, s4 # the parameters of dot function
    mv a2, t2
    li a3, 4
    jal fread

    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    addi sp, sp, 12

    li t5, 4
    bne a0, t5, exit91 # if a0 != t0 then exit91
    addi t0, t0, 1 # i++
    blt t0, s5, loop_continue # if t1 < t5 then inner_loop_continue

loop_end:
    # Epilogue
    mv a1, s4
    jal fclose
    bne a0, x0, exit92 # if a0 != x0 then exit92

    mv a0, s3
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

exit88:
    li a1, 88
    j exit2

exit90:
    li a1, 90
    j exit2

exit91:
    li a1, 91
    j exit2

exit92:
    li a1, 92
    j exit2
