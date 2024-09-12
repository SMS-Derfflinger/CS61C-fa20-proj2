.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Prologue
    li t0, 5
    bne a0, t0, exit89 # If there are an incorrect number of command line args

    mv s0, a0
    mv s1, a1
    mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    #TODO: Replace the alias with registers

    # Load pretrained m0
    li a0, 8
    jal malloc
    beq a0, x0, exit88  # if a0 == x0 then exit88
    mv newMemory0, a0
    lw a0, 4(s1)    # <M0_PATH>
    mv a1, newMemory0
    addi a2, newMemory0, 4
    jal read_matrix
    mv m0pointer, a0

    # Load pretrained m1
    li a0, 8
    jal malloc
    beq a0, x0, exit88  # if a0 == x0 then exit88
    mv newMemory1, a0
    lw a0, 8(s1)    # <M1_PATH>
    mv a1, newMemory1
    addi a2, newMemory1, 4
    jal read_matrix
    mv m1pointer, a0

    # Load input matrix
    li a0, 8
    jal malloc
    beq a0, x0, exit88  # if a0 == x0 then exit88
    mv newMemoryin, a0
    lw a0, 12(s1)    # <INPUT_PATH>
    mv a1, newMemoryin
    addi a2, newMemoryin, 4
    jal read_matrix
    mv inpointer, a0

    # =====================================
    # RUN LAYERS
    # =====================================

    # 1. LINEAR LAYER:    m0 * input
    lw t0, 0(newMemory0)
    lw t1, 4(newMemory1)
    mul t0, t0, t1  # size of array
    slli a0, t0, 2
    jal malloc
    beq a0, x0, exit88
    mv hidden_layer, a0

    mv a0, m0pointer
    lw a1, 0(newMemory0)
    lw a2, 4(newMemory0)
    mv a3, m1pointer
    lw a4, 0(newMemory1)
    lw a5, 4(newMemory1)
    mv a6, hidden_layer
    jal matmul

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    lw t0, 0(newMemory0)
    lw t1, 4(newMemory1)
    mul a1, t0, t1 # number of elements in the array
    mv a0, hidden_layer
    jal relu

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 0(newMemory1)    # number of rows of m1
    lw t1, 4(newMemoryin)   # number of cols of input
    mul a0, t0, t1  # size of array
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exit88
    mv scores, a0

    mv a0, m1pointer
    lw a1, 0(newMemory1)
    lw a2, 4(newMemory1)
    mv a3, hidden_layer
    lw a4, 0(newMemory0)
    lw a5, 4(newMemoryin)
    mv a6, scores
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)   # OUTPUT_PATH
    mv a1, scores
    lw a2, 0(newMemory1)
    lw a3, 4(newMemoryin)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, scores
    lw t0, 0(newMemory1)
    lw t1, 4(newMemory1)
    mul a1, t0, t1
    jal argmax
    mv largest, a0

    # Print classification
    bne s2, x0, return
    mv a1, largest
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

return:


    ret

exit88:
    li a1, 88
    j exit2

exit89:
    li a1, 89
    j exit2
