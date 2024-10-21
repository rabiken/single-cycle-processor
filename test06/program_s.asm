.data
.align 2

.text
j main

init:
  lw s0, 0x4(x0)	# Load the array size
  lw s1, 0x8(x0)	# Load the pointer to the address of the array.
  jalr ra

# Calculate floor_log(float x), where x is a0
# a0 = (int) floor_log(float a0);
floor_log:
  addi t1, x0, 23	# t1 = 23;
  srl a0, a0, t1	# a0 = a0 >> 23;
  addi t1, x0, 127	# t1 = 127;
  sub a0, a0, t1	# a0 = a0 - 127;
  jalr ra		# return

done:
j done

main:
  jal ra, init		# Initialize the task.
  
  # Task
  addi t0, x0, 0x0	# Iterator i
  loop1:
    beq t0, s0, done	# if i == #size of the array, done
    lw a0, 0x0(s1)      # a0 <- the element s1 is pointing to
    jal ra, floor_log   # calculate the value to replace
    sw a0, 0x0(s1)	# Write back the calculated value
    addi s1, s1, 0x4	# Point the next element.
    addi t0, t0, 0x1	# i = i + 1
    j loop1		# loop
  
  
  
  