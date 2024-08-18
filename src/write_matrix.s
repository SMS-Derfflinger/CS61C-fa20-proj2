.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    mv a1, s0
    li a2, 1
    jal fopen
    mv s4, a0 # file descriptor
    li t0, -1
    beq a0, t0, exit93 # if a0 == t0 then exit93

    li a0, 8
    jal malloc
    mv t0, a0
    sw s2, 0(t0)
    sw s3, 4(t0)

    mv a1, s4
    mv a2, t0
    li a3, 2
    li a4, 4 
    jal fwrite
    li t0, 1
    blt a0, t0, exit94 # if a0 < t0 then exit94

    mul t0, s2, s3 # the number of matrix
    mv a1, s4
    mv a2, s1
    mv a3, t0
    li a4, 4
    jal fwrite
    mul t0, s2, s3
    blt a0, t0, exit94 # if a0 < t0 then exit94

    # Epilogue
    mv a1, s4
    jal fclose
    bne a0, x0, exit95 # if a0 != x0 then exit95

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    ret

exit93:
    li a1, 93
    j exit2

exit94:
    li a1, 94
    j exit2

exit95:
    li a1, 95
    j exit2
