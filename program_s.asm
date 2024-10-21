.data
.align 2

.text
j main

init:
  lw a0, 0x4(x0)	# Load the array size
  lw a1, 0x8(x0)	# Load the pointer to the address of the array.
  ret

# Calculate floor_log(float x), where x is a2
# a2 = (int) floor_log(float a2);
calc:
  addi t1, x0, 23	# t1 = 23;
  srl a2, a2, t1	# a2 = a2 >> 23;
  addi t1, x0, 127	# t1 = 127;
  sub a2, a2, t1	# a2 = a2 - 127;
  j calc_ret		# return

do_task:
  addi t0, x0, 0x0	# Iterator i
  loop1:
    lw a2, 0x0(a1)      # a2 <- the element a1 is pointing to
    j calc		# calculate the value to replace
    calc_ret:
    sw a2, 0x0(a1)	# Write back the calculated value
    addi a1, a1, 0x4	# Point the next element.
    addi t0, t0, 0x1	# i = i + 1
  blt t0, a0, loop1	# Repeat while i < array size (a0)
  ret

done:
j done

main:
  jal ra, init		# Initialize the task.
  jal ra, do_task		# Replace all the array elements with the calculated values.
  j done		# Done.
  
  
  