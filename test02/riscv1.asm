.data                  # directive indicating start of the data segment
.align  2              # set data alignment to 4 


.text                  # beginning of the text segment (or code segment)

j start

start:
addi t1, x0, 0xff
sw t1, 0x0(x0)
addi t2, t1, -0xf
sw t2, 0x4(x0)


