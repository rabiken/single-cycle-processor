.data                  # directive indicating start of the data segment
.align  2              # set data alignment to 4 bytes

array:                 # label - name of the memory block
.word  3, 7, 3, 5, 1   # values in the array to increment...
res:
.float


.text                  # beginning of the text segment (or code segment)

j start

start:
lui   s0, %hi(array)         # store address of the "array" to register s0
lw t3, 0x0(s0)
lw t4, 0x4(s0)
lui s1, %hi(res)
sw t3, 0x0(s1)
sw t4, 0x4(s1)