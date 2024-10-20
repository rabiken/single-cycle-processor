.data                  # directive indicating start of the data segment
.align  2              # set data alignment to 4 


.text                  # beginning of the text segment (or code segment)

j start

fail:
sw t6, 0x20(x0)# store the error code at 0x20
fail_loop:
j fail_loop

success:
j success

start:
addi t1, x0, 0x1	# success flag
addi t6, x0, 0x11 # error code 1

blt x0, x0, fail


success1:
sw t1, 0x0(x0)	# send data at addres 0x0 will be 1
addi t6, x0, 0x12 # error code 2

addi t2, x0, 0x88
blt t2, x0, fail
blt x0, t2 success2
j fail
success2:
sw t1, 0x4(x0)
addi t6, x0, 0x13 # error code 3

addi t3, x0, 0x97
blt t3, t2, fail
blt t2, t3 success3
j fail

success3:
sw t1, 0x8(x0)


j success