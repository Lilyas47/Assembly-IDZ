.data
size:          	.asciz "Enter size of an array (from 1 to 10):\n"
outofrange_error:	.asciz "Oops, wrong size of an array!"
enter:        	.asciz "Enter integer values to array:\n"
array_B_tip:     	.asciz "Array B values:\n"
zero_size_tip:	.asciz "No such values in array A!\n"
endl:	.asciz "\n"
	
array_A:  .word  10  
array_B:  .word  10

.text 	

	li a6 0
	# user tip
	la a0 size
	li a7 4
	ecall
	# enter size of an array
	li a7 5
      	ecall
      	
      	#check if array size is ok
      	jal check_limits
      	
      	# check function return 
      	li a1 1
      	beq a0 a1 correct_size
      	
      	incorrect_size: 
      	# print user error tip
      	li a7 4
      	la a0 outofrange_error
      	ecall
      	j end_programm
      	
      	correct_size: 
      	# go to input array A subprogramm
      	jal input_array
      	
      	# go to form array B subprogramm
      	jal form_array
      	
      	# print array B
      	jal print_array
      	

	# exit programm
	end_programm:
	li a7 10 
      	ecall
  	
 .text
 check_limits:
 	# checking if array size is ok (from 1 to 10)
 	# returns 1 (true) if input is ok, 0 (false) if intput is out of range
 	# return value - array A size - is in a0 register
 	
 	addi sp sp -4
 	sw ra (sp)
 	
 	mv t0 a0 # array A size is in t0 now
 	li a0 1 # function return value now is true
 	
 	# do checking
 	li a2 0
 	ble t0 a2 incorrect_size_check
 	
 	li a2 10
 	bgt t0 a2 incorrect_size_check
 	
 	j end_size_check
 	
 	incorrect_size_check:
 	li a0 0
 	
 	end_size_check:
 	# renew stack
 	lw ra (sp)
 	addi sp sp 4
 	ret
 
 .text 
 input_array:
 	# reads values from console and forms array A
 	# no patrameters
 	# no return value
 	addi sp sp -4
 	sw ra (sp)
 	#mv a0 t0 # array length is now in t0 register
 
 	la a0 enter
 	li a7 4
 	ecall
 	
 	la t1 array_A
 	
      	li t2 1 # store index
      	while_read:
      	li a7 5 # read number
      	ecall
      	sw a0 (t1)
      	addi t1 t1 4
      	addi t2 t2 1
      	bleu t2 t0 while_read
      	
      	# renew stack
      	lw ra (sp)
      	addi sp sp 4
 	ret
 .text
 form_array:
 	# forms array B
 	# no parameters
 	# returns array B size in a0 register
 	
 	addi sp sp -4
 	sw ra (sp)
 	
 	# load arrays
      	la t1 array_A #(array A size is in t0)
      	la t2 array_B
      	
      	lw a1 (t1) # load 1st array A value to a1
      	addi t1 t1 4 # shift to 2nd value 
      	li t3 0 # array B size is in t3 now
      	li t4 0 # store index - t4
      	li a5 0
      	
      	# form array B
      	while_write:                         
      	lw a2 (t1)
      	# check condition (current element < 0)
      	bgt a6 a5 end_if_B
      	bgt a2 a5 change_a6
      	ble a2 a5 check_a6
      
      	j end_if_B
      	
      	# if a2 > 0 and a6 isn`t > 0, we should change a6
      	change_a6:
      	addi a6 a6 1
      	j end_if_B
      	
      	# if a6 <= a5, we should add a6 in B
      	check_a6:
      	ble a6 a5 store
      	
      	store:
      	# save number and move index
      	addi a2 a2 -5
      	sw a2 (t2)
      	addi t2 t2 4 
      	addi t3 t3 1
      	
      	end_if_B:
      	
      	addi t4 t4 1
      	mv a1 a2 # move current element to previous
      	addi t1 t1 4
      	blt t4 t0 while_write
 	
 	mv a0 t3 # set return value
 	
 	# end subprogramm
  	lw ra (sp)
  	addi sp sp 4
  	ret
 .text
 print_array: 	
 	# prints array B
 	# parameter is in a0 - array B size
 	# no return value
 	
 	
 	addi sp sp -4
 	sw ra (sp)
 	
 	mv t0 a0 # array size in t0 now
 	
 	#check if array B is not empty
 	li a0 0 
 	beq t0 a0 zero_size
 	
 	# print user tips
      	la a0 array_B_tip
      	li a7 4
      	ecall
      	
      	la t2 array_B
      	li t3 0
      	
      	while_print:
      	# print array element and endl
      	lw a0 (t2)
      	li a7 1
      	ecall 
      	li a7 4
      	la a0 endl
      	ecall
      	
      	addi t3 t3 1
      	addi t2 t2 4
      	blt t3 t0 while_print
      	j end_subpr
      	
      	
      	# if array B is empty
      	zero_size:
      	la a0 zero_size_tip
      	li a7 4
      	ecall
      	
      	end_subpr:
      	# end subprogramm
      	lw ra (sp)
  	addi sp sp 4
  	ret
