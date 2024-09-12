# CS61C-fa20-proj2

This repository contains my solutions to the CS61C-fa20-proj2, which written all RISC-V assembly code necessary to run a simple Artificial Neural Network (ANN) on the Venus RISC-V simulator.
```
.
├── inputs (test inputs)
├── outputs (some test outputs)
├── README.md
├── src
│   ├── argmax.s (partA)
│   ├── classify.s (partB)
│   ├── dot.s (partA)
│   ├── main.s (do not modify)
│   ├── matmul.s (partA)
│   ├── read_matrix.s (partB)
│   ├── relu.s (partA)
│   ├── utils.s (do not modify)
│   └── write_matrix.s (partB)
├── tools
│   ├── convert.py (convert matrix files for partB)
│   └── venus.jar (RISC-V simulator)
└── unittests
    ├── assembly (contains outputs from unittests.py)
    ├── framework.py (do not modify)
    └── unittests.py (partA + partB)
```


## Here's what I did in project 2:

- [x] Part A1
    * Implement the function in which takes in a 1D vector and applies the rectifier function on each element, modifying it in place.
- [x] Part A2
    * Implement the argmax function in src/argmax.s which takes in a 1D vector and returns the index of the largest element.
- [x] Part A3.1
    * Implement the dot function in src/dot.s which takes in two vectors and returns their dot product.
- [x] Part A3.2
    * Implement the matmul function in src/matmul.s which takes in two matrices, m0 and m1 in row-major format and multiplies them, storing the resulting matrix C in pre-allocated memory.
- [x] Part B1
    * Implement the read_matrix function in src/read_matrix.s which uses the file operations we described above to read a binary matrix file into memory.
- [x] Part B2
    * Implement the write_matrix function in src/write_matrix.s which uses the file operations we described above to write from memory to a binary matrix file.
- [x] Part B3
    * Implement the classify function in src/classify.s.
    * load m0, m1, and the input matrices into memory by making multiple calls to read_matrix, using command line arguments. 
    * Next, use those three matrices to calculate the scores for our input, consists of a matrix multiplication with m0, followed by a relu on the result, and then a second matrix multiplication with m1. At the end of this, will have a matrix of scores for each classification, then pick the index with the highest score, and that index is the classification for input.
    * Given two weight matrices m0 and m1, along with an input matrix input, the pseudocode to generate the scores for each class is as follows:
    ```
    hidden_layer = matmul(m0, input)
    relu(hidden_layer) # Recall that relu is performed in-place
    scores = matmul(m1, hidden_layer)
    ```

You can see the introduction of this project on the course's home page: [course website](https://cs61c.org/fa20/), or in this website: [cs61c/projects/proj2](https://www.learncs.site/docs/curriculum-resource/cs61c/projects/proj2).
