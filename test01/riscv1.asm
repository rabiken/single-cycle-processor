.data                  # directive indicating start of the data segment
.align  2              # set data alignment to 4 


.text                  # beginning of the text segment (or code segment)

j start

start:
lw t1, 0x4(x0)
sw t1, 0x8(x0)