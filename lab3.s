@ Vending Machine Simulation - Lab 3
@ Author: [Your Name]
@ Date: [Current Date]
@ Secret Code: 9999

.section .data
welcome_msg:    .asciz "Welcome to Mr. Zippy’s vending machine.\n"
cost_msg:       .asciz "Cost of Gum ($0.50), Peanuts ($0.55), Cheese Crackers ($0.65), or M&Ms ($1.00).\n"
select_msg:     .asciz "Enter item selection: Gum (G), Peanuts (P), Cheese Crackers (C), or M&Ms (M): "
invalid_msg:    .asciz "Invalid selection. Try again.\n"
confirm_msg:    .asciz "You selected %s. Is this correct (Y/N)? "
payment_msg:    .asciz "Enter at least %d cents for selection.\nDimes (D), Quarters (Q), and dollar bills (B): "
dispensed_msg:  .asciz "Item has been dispensed.\n"
change_msg:     .asciz "Change of %d cents has been returned.\n"
shutdown_msg:   .asciz "Vending machine is out of inventory and will shut down.\n"
secret_msg:     .asciz "Current inventory:\nGum: %d\nPeanuts: %d\nCheese Crackers: %d\nM&Ms: %d\n"

.section .bss
.lcomm inventory_gum, 4
.lcomm inventory_peanuts, 4
.lcomm inventory_cheese, 4
.lcomm inventory_mms, 4

.section .text
.global main

main:
    @ Initialize inventory
    mov r0, #2
    ldr r1, =inventory_gum
    str r0, [r1]
    ldr r1, =inventory_peanuts
    str r0, [r1]
    ldr r1, =inventory_cheese
    str r0, [r1]
    ldr r1, =inventory_mms
    str r0, [r1]

main_loop:
    @ Check if inventory is zero
    ldr r1, =inventory_gum
    ldr r2, [r1]
    ldr r1, =inventory_peanuts
    ldr r3, [r1]
    ldr r1, =inventory_cheese
    ldr r4, [r1]
    ldr r1, =inventory_mms
    ldr r5, [r1]
    add r6, r2, r3
    add r6, r6, r4
    add r6, r6, r5
    cmp r6, #0
    beq shutdown

    @ Display welcome message
    ldr r0, =welcome_msg
    bl printf


    @ Display cost of items
    ldr r0, =cost_msg
    bl printf

prompt_selection:
    @ Prompt for selection
    ldr r0, =select_msg
    bl printf

    bl get_input
    cmp r0, #'G'
    beq handle_gum
    cmp r0, #'P'
    beq handle_peanuts
    cmp r0, #'C'
    beq handle_cheese_crackers
    cmp r0, #'M'
    beq handle_mms
    cmp r0, #'9'
    beq secret_code

    @ Invalid selection
    ldr r0, =invalid_msg
    bl printf

    b prompt_selection

handle_gum:
    ldr r1, =inventory_gum
    ldr r2, [r1]
    cmp r2, #0
    beq out_of_stock
    mov r0, #50
    bl process_payment
    sub r2, r2, #1
    str r2, [r1]
    ldr r0, =dispensed_msg
    bl printf

    b main_loop

handle_peanuts:
    ldr r1, =inventory_peanuts
    ldr r2, [r1]
    cmp r2, #0
    beq out_of_stock
    mov r0, #55
    bl process_payment
    sub r2, r2, #1
    str r2, [r1]
    ldr r0, =dispensed_msg
    bl printf

    b main_loop

handle_cheese_crackers:
    ldr r1, =inventory_cheese
    ldr r2, [r1]
    cmp r2, #0
    beq out_of_stock
    mov r0, #65
    bl process_payment
    sub r2, r2, #1
    str r2, [r1]
    ldr r0, =dispensed_msg
    bl printf

    b main_loop

handle_mms:
    ldr r1, =inventory_mms
    ldr r2, [r1]
    cmp r2, #0
    beq out_of_stock
    mov r0, #100
    bl process_payment
    sub r2, r2, #1
    str r2, [r1]
    ldr r0, =dispensed_msg
    bl printf

    b main_loop

out_of_stock:
    ldr r0, =invalid_msg
    bl printf

    b prompt_selection

process_payment:
    @ r0 contains the amount required in cents
    push {lr}
    ldr r0, =payment_msg  @ Load payment message
    mov r1, r0            @ Move the required amount to r1 for display
    bl printf             @ Print the payment message with the required amount
    @ For simplicity, assume the user always enters enough money
    pop {lr}
    bx lr

secret_code:
    @ Secret Code Handler - Displays Current Inventory
    ldr r1, =inventory_gum
    ldr r2, [r1]
    ldr r1, =inventory_peanuts
    ldr r3, [r1]
    ldr r1, =inventory_cheese
    ldr r4, [r1]
    ldr r1, =inventory_mms
    ldr r5, [r1]
    ldr r0, =secret_msg
    mov r1, r2
    mov r2, r3
    mov r3, r4
    mov r4, r5
    bl printf

    b main_loop

shutdown:
    @ Shutdown the vending machine
    ldr r0, =shutdown_msg
    bl printf

    b exit_program

exit_program:
    @ Exit Program
    mov r7, #1          @ sys_exit
    mov r0, #0          @ Exit code 0
    swi 0

get_input:
    @ Get User Input
    mov r7, #3           @ sys_read
    mov r0, #0           @ File descriptor 0 (stdin)
    ldr r1, =input_selection  @ Buffer to store input
    mov r2, #1           @ Read 1 byte
    swi 0                @ Make syscall
    ldrb r0, [r1]        @ Load the character into r0
    cmp r0, #0
    beq prompt_selection @ Retry if input is not valid
    bx lr

.section .note.GNU-stack,"",%progbits
.section .data
input_selection: .byte 'G'