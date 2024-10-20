.data                  # directive indicating start of the data segment
.align  2              # set data alignment to 4 


.text                  # beginning of the text segment (or code segment)

j start

fail:
  sw s0, 0x0(x0)		# Store the number of tests
  fail_loop:
  j fail_loop

init:
  addi s0, zero, 0x1	# Test number
  addi s1, zero, 0x0	# The address of the result in data memory
  addi a0, zero, 0x33	# positive int0
  addi a1, zero, 0x3	# positive int1
  addi a2, zero, -0x34  # negative int2
  addi a3, zero, -0x2	# negative int3
  ret			# return

test1:
  # pos pos
  add t0, a0, a1	# test
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  # pos neg
  add t0, a0, a2
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  # neg neg
  add t0, a2, a3
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  ret			# return
  
test2:
  # pos pos
  sub t0, a0, a1	# test
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  # pos neg
  sub t0, a0, a2
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  # neg neg
  sub t0, a2, a3
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  ret			# return

test3:
  # pos pos
  and t0, a0, a1	# test
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  # pos neg
  and t0, a0, a2
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  # neg neg
  and t0, a2, a3
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  ret			# return
  
test4:
  # pos pos
  srl t0, a0, a1	# test
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  # pos neg
  srl t0, a0, a2
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  # neg neg
  srl t0, a2, a3
  sw t0, 0x0(s1)	# store the result at s1
  addi s1, s1, 0x4	# increment the buffer in data mem
  ret			# return
  

end:
j end

start:
  jal ra, init
  # Test 1 add 
  jal ra, test1
  jal ra, test2
  jal ra, test3
  jal ra, test4
  j end

    