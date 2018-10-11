#include <mips/regdef.h>

#define SS 48
#define O_RA 40
#define O_FP 36
#define O_GP 32

#define ARG_0 48
#define ARG_1 52
#define ARG_2 56

#define O_LEFT 16
#define O_RIGHT 20
#define O_PIVOT 24
#define DIR_PIVOT 28

.text
.align 		2
.globl 		qsortMIPS
.ent 		qsortMIPS
# void qsortMIPS(char** left, char** right, int numeric);
# 	a0  ->  left
# 	a1  ->  right
# 	a2  ->  numeric

# STACK
# 
	# 48
	#	 +--------------+
	# 44 |//////////////|
	#	 +--------------+
	# 40 |		ra 		|
	#	 +--------------+
	# 36 |		fp 		|
	#	 +--------------+
	# 32 |		gp 		|
	#	 +--------------+
	# 28 | 	 pivot dir  |
	#	 +--------------+
	# 24 |	   pivot	|
	#	 +--------------+
	# 20 |	   right 	|
	#	 +--------------+
	# 16 |	   left		|
	#	 +--------------+
	# 12 |//////////////|
	#	 +--------------+
	# 8	 |		a2 		|
	#	 +--------------+
	# 4	 |		a1 		|
	#	 +--------------+
	# 0	 |		a0 		|
	#	 +--------------+


qsortMIPS:
	.set 	noreorder
	.cpload t9
	.set 	reorder

	subu 	sp, sp, SS 		# Create Stack Frame
	sw 		ra, O_RA(sp) 	# Save Return Address
	sw 		$fp, O_FP(sp)
	sw 		gp, O_GP(sp)

	#Cargo los args en el stack
	sw 		a0, ARG_0(sp) # &left
	sw 		a1, ARG_1(sp) # &right
	sw 		a2, ARG_2(sp) # &numeric

	lw 		t1, ARG_0(sp) # t1 = limit_left
	lw 		t2, ARG_1(sp) # t2 = limit_right
	lw 		t6, ARG_0(sp) # t6 = left
	lw		t7, ARG_1(sp) # t7 = right

	sw 		t6, O_LEFT(sp)
	sw 		t7, O_RIGHT(sp)

	# PIVOT - t3 = pivot
	# pivot = ( ( (t6/4) + (t7/4) ) / 2)*4
	srl 	t8, t6, 2
	srl 	t9, t7, 2
	addu 	t3, t8, t9
	srl 	t3, t3, 1
	sll 	t3, t3, 2

	sw 		t3, O_PIVOT(sp)
	lw		t3, 0(t3)
	sw 		t3, DIR_PIVOT(sp)
	# lbu 	t8, 0(t3) # t8 = *pivot

while_loop:
	lw 		t6, O_LEFT(sp)
	lw		t7, O_RIGHT(sp)
	bgtu 	t6, t7, end_while_loop # left > right

while_left_loop:
	lw 		t6, O_LEFT(sp)
	lw 		t2, ARG_1(sp)

	bgeu 	t6, t2, while_right_loop # branch (left >= limit_right), while_right_loop

#--------------------------------

	lw 		a0, 0(t6)
	lw 		a1, DIR_PIVOT(sp)

	lw 		a2, ARG_2(sp)
	beqz	a2, compare_str_1

compare_int_1: # compare_int(list[left], pivot)
	la		t9, compare_int
	b compare_call_1

compare_str_1: # compare_str(list[left], pivot)
	la		t9, compare_str
	b 		compare_call_1

compare_call_1:
	jal 	t9

	bgez 	v0, while_right_loop

#--------------------------------

	lw 		t6, O_LEFT(sp)
	addu 	t6, t6, 4 # left++
	sw 		t6, O_LEFT(sp)
	b 		while_left_loop

while_right_loop:
	lw 		t1, ARG_0(sp)
	lw 		t7, O_RIGHT(sp)

	bleu 	t7, t1, end_while_left_right_loop # branch (right <= limit_left), end_while_left_right_loop
	
#--------------------------------

	lw 		a0, DIR_PIVOT(sp)
	lw 		a1, 0(t7)

	lw		a2, ARG_2(sp)
	beqz	a2, compare_str_2

compare_int_2:	# compare_int(pivot, list[right])
	la		t9, compare_int
	b 		compare_call_2

compare_str_2:	# compare_str(pivot, list[right])
	la		t9, compare_str
	b 		compare_call_2

compare_call_2:
	jal 	t9

	bgez 	v0, end_while_left_right_loop

#--------------------------------

	lw 		t7, O_RIGHT(sp)
	subu 	t7, t7, 4 # right--
	sw 		t7, O_RIGHT(sp)
	b 		while_right_loop

end_while_left_right_loop:
	lw 		t6, O_LEFT(sp)
	lw 		t7, O_RIGHT(sp)
	bgtu 	t6, t7, while_loop # left > right

swap:
	lw 		t4, 0(t6)
	lw		t5, 0(t7)
	sw 		t5, 0(t6)
	sw 		t4, 0(t7)

	lw 		t6, O_LEFT(sp)
	addu 	t6, t6, 4 # left++
	sw 		t6, O_LEFT(sp)
	lw 		t7, O_RIGHT(sp)
	subu 	t7, t7, 4 # right--
	sw 		t7, O_RIGHT(sp)
	b 		while_loop

end_while_loop:
	sw 		t6, O_LEFT(sp)
	sw 		t7, O_RIGHT(sp)

qsort_left:
	lw 		t1, ARG_0(sp)
	lw 		t7, O_RIGHT(sp)
	bgeu 	t1, t7, qsort_right # limit_left >= right

	lw 		a0, ARG_0(sp) # a0 - limit_left
	lw 		a1, O_RIGHT(sp) # a1 - right
	la 		t9, qsortMIPS
	jal 	t9
	lw 		a0, ARG_0(sp)
	lw 		a1, ARG_1(sp)

qsort_right:
	lw		t2, ARG_1(sp)
	lw		t6, O_LEFT(sp)
	bleu 	t2, t6, _exit # limit_right <= left

	lw	 	a0, O_LEFT(sp) # a0 - left
	lw 		a1, ARG_1(sp) # a1 - limit_right
	la 		t9, qsortMIPS
	jal 	t9
	lw 		a0, ARG_0(sp)
	lw 		a1, ARG_1(sp)

_exit:
	#Desarmo el Stack Frame
	lw 		ra, O_RA(sp)
	lw 		$fp, O_FP(sp)
	lw 		gp, O_GP(sp) 
	addu 	sp, sp, SS
	j 		ra

.end qsortMIPS

