BITS 32

section .data

; ============================================================
; MEDITRACK - SMART PHARMACY MANAGEMENT SYSTEM
; 32-bit x86 Linux NASM
;
; Main Features:
; 1. Medicine Management
; 2. Inventory Management
; 3. Process Sale
; 4. Sales Summary
; 5. Exit
;
; Medicine:
; - 10 array slots
; - ID 0 means FREE slot
; - Add Medicine searches for first free slot
; - Search is performed by medicine name
; - Removed medicine slots can be reused
;
; Sales:
; - Multiple medicines per sale
; - Stock reservation during current sale
; - 10% discount when quantity of ONE medicine >= 5
; - Stock is updated only after successful payment
; ============================================================


; ============================================================
; MAIN MENU
; ============================================================

menu db 10
     db "========================================",10
     db "          MEDITRACK PHARMACY SYSTEM",10
     db "========================================",10
     db "1. Medicine Management",10
     db "2. Inventory Management",10
     db "3. Process Sale",10
     db "4. Sales Summary",10
     db "5. Exit",10
     db "Enter choice: ",0


; ============================================================
; MEDICINE MANAGEMENT MENU
; ============================================================

med_menu db 10
         db "--------- MEDICINE MANAGEMENT ---------",10
         db "1. View Medicines",10
         db "2. Add Medicine",10
         db "3. Search Medicine by Name",10
         db "4. Remove Medicine",10
         db "5. Back",10
         db "Enter choice: ",0


; ============================================================
; INVENTORY MANAGEMENT MENU
; ============================================================

inv_menu db 10
         db "--------- INVENTORY MANAGEMENT ---------",10
         db "1. View Stock",10
         db "2. Low Stock Check",10
         db "3. Restock Medicine",10
         db "4. Back",10
         db "Enter choice: ",0


; ============================================================
; GENERAL MESSAGES
; ============================================================

msg_invalid db "Invalid choice.",10,0

msg_press db 10
          db "Press Enter to continue...",0


; ============================================================
; MEDICINE MESSAGES
; ============================================================

msg_full db "No free medicine slot is available.",10,0

msg_id db "Enter medicine ID: ",0

msg_name db "Enter medicine name: ",0

msg_price db "Enter price (RM): ",0

msg_stock db "Enter stock quantity: ",0

msg_search db "Enter medicine name to search: ",0

msg_found db 10
          db "Medicine found:",10,0

msg_not_found db "Medicine not found.",10,0

msg_removed db "Medicine removed successfully.",10,0

msg_added db "Medicine added successfully.",10,0


; ============================================================
; INVENTORY MESSAGES
; ============================================================

msg_updated db "Stock updated successfully.",10,0

msg_low db "LOW STOCK",0

msg_ok db "OK",0

msg_restock db "Enter medicine name to restock: ",0

msg_qty db "Enter quantity: ",0


; ============================================================
; SALES MESSAGES
; ============================================================

msg_sale_name db 10
              db "Enter medicine name to buy: ",0

msg_sale_qty db "Enter quantity: ",0

msg_insufficient db "Insufficient stock.",10,0

msg_invalid_qty db "Invalid quantity.",10,0

msg_more db "Add another medicine? (1=Yes, 0=No): ",0

msg_cart_full db "Maximum number of different medicines reached.",10,0

msg_subtotal db 10
             db "Subtotal: RM ",0

msg_discount db "Discount: RM ",0

msg_total db "Total: RM ",0

msg_payment db "Enter payment amount (RM): ",0

msg_payment_low db "Payment is less than the total.",10,0

msg_change db "Change: RM ",0

msg_sale_done db "Sale completed successfully.",10,0

msg_cancel db "Sale cancelled.",10,0


; ============================================================
; SALES SUMMARY MESSAGES
; ============================================================

msg_total_sales db 10
                db "Total completed sales: ",0

msg_revenue db "Total revenue: RM ",0

msg_items_sold db "Total items sold: ",0

msg_total_discount db "Total discounts given: RM ",0


; ============================================================
; DISPLAY LABELS
; ============================================================

msg_id_label db "ID: ",0

msg_name_label db "Name: ",0

msg_price_label db "Price: RM ",0

msg_stock_label db "Stock: ",0


newline db 10,0

num_zero db "0",0


; ============================================================
; MEDICINE ARRAYS
;
; 10 medicine slots
;
; ID 0 = FREE
;
; Slot 0 = Paracetamol
; Slot 1 = Vitamin C
; Slot 2 = Cough Syrup
; Slot 3 = Antacid
; Slot 4 = Allergy Tablets
; Slot 5-9 = FREE
; ============================================================

medicine_ids:
    dd 101,102,103,104,105
    dd 0,0,0,0,0

medicine_prices:
    dd 5,12,15,8,10
    dd 0,0,0,0,0


medicine_stocks:
    dd 50,30,20,40,25
    dd 0,0,0,0,0


; ============================================================
; MEDICINE NAME ARRAY
;
; Every slot is exactly 20 bytes.
; ============================================================

medicine_names:

    ; Slot 0
    db "Paracetamol",0
    times 8 db 0

    ; Slot 1
    db "Vitamin C",0
    times 10 db 0

    ; Slot 2
    db "Cough Syrup",0
    times 8 db 0

    ; Slot 3
    db "Antacid",0
    times 12 db 0

    ; Slot 4
    db "Allergy Tablets",0
    times 4 db 0

    ; Slot 5
    times 20 db 0

    ; Slot 6
    times 20 db 0

    ; Slot 7
    times 20 db 0

    ; Slot 8
    times 20 db 0

    ; Slot 9
    times 20 db 0


; ============================================================
; SALES CART ARRAYS
;
; Maximum 10 different medicine entries per sale.
; ============================================================

cart_count dd 0

cart_index:
    times 10 dd 0

cart_qty:
    times 10 dd 0

; Temporary reservation array.
; Reserved quantities are tracked during current sale.

cart_reserved:
    times 10 dd 0

cart_total:
    times 10 dd 0


; ============================================================
; CURRENT SALE VARIABLES
; ============================================================

sale_subtotal dd 0

sale_discount dd 0

sale_items dd 0

sale_total dd 0

sale_change dd 0


; ============================================================
; SALES SUMMARY VARIABLES
; ============================================================

total_sales dd 0

total_revenue dd 0

total_items_sold dd 0

total_discount_given dd 0


; ============================================================
; TEMPORARY VARIABLES
; ============================================================

current_index dd 0

search_result dd 0


section .bss

; Keyboard input buffer
input resb 64

; Number printing buffer
num_buffer resb 12


section .text

global _start


; ============================================================
; PROGRAM START
; ============================================================

_start:

main_loop:

    mov eax,menu
    call print_string

    call read_number

    cmp eax,1
    je medicine_management

    cmp eax,2
    je inventory_management

    cmp eax,3
    je process_sale

    cmp eax,4
    je sales_summary

    cmp eax,5
    je exit_program

    mov eax,msg_invalid
    call print_string

    call wait_enter

    jmp main_loop


; ============================================================
; MEDICINE MANAGEMENT
; ============================================================

medicine_management:

med_loop:

    mov eax,med_menu
    call print_string

    call read_number

    cmp eax,1
    je view_medicines

    cmp eax,2
    je add_medicine

    cmp eax,3
    je search_medicine

    cmp eax,4
    je remove_medicine

    cmp eax,5
    je main_loop

    mov eax,msg_invalid
    call print_string

    call wait_enter

    jmp med_loop


; ============================================================
; VIEW ALL MEDICINES
; ============================================================

view_medicines:

    mov ecx,0


view_loop:

    cmp ecx,10
    jge view_done

    ; ID 0 means FREE
    cmp dword [medicine_ids+ecx*4],0
    je view_next

    mov [current_index],ecx

    call display_medicine


view_next:

    inc ecx

    jmp view_loop


view_done:

    call wait_enter

    jmp med_loop


; ============================================================
; ADD MEDICINE
;
; Searches for first free slot.
; ============================================================

add_medicine:

    call find_free_slot

    cmp eax,-1
    je add_full

    ; Save free slot
    mov [current_index],eax


    ; --------------------------------------------------------
    ; ENTER ID
    ; --------------------------------------------------------

    mov eax,msg_id
    call print_string

    call read_number

    cmp eax,0
    je add_invalid

    mov ebx,[current_index]

    mov [medicine_ids+ebx*4],eax


    ; --------------------------------------------------------
    ; ENTER NAME
    ; --------------------------------------------------------

    mov eax,msg_name
    call print_string

    call read_line

    mov eax,[current_index]

    call copy_input_to_name


    ; --------------------------------------------------------
    ; ENTER PRICE
    ; --------------------------------------------------------

add_price:

    mov eax,msg_price
    call print_string

    call read_number

    cmp eax,0
    jle add_price

    mov ebx,[current_index]

    mov [medicine_prices+ebx*4],eax


    ; --------------------------------------------------------
    ; ENTER STOCK
    ; --------------------------------------------------------

add_stock:

    mov eax,msg_stock
    call print_string

    call read_number

    cmp eax,0
    jl add_stock

    mov ebx,[current_index]

    mov [medicine_stocks+ebx*4],eax


    mov eax,msg_added
    call print_string

    call wait_enter

    jmp med_loop


add_full:

    mov eax,msg_full
    call print_string

    call wait_enter

    jmp med_loop


add_invalid:

    mov eax,msg_invalid
    call print_string

    call wait_enter

    jmp med_loop


; ============================================================
; SEARCH MEDICINE BY NAME
; ============================================================

search_medicine:

    mov eax,msg_search
    call print_string

    call read_line

    call find_by_name

    cmp eax,-1
    je search_not_found

    mov [current_index],eax

    mov eax,msg_found
    call print_string

    call display_medicine

    call wait_enter

    jmp med_loop


search_not_found:

    mov eax,msg_not_found
    call print_string

    call wait_enter

    jmp med_loop


; ============================================================
; REMOVE MEDICINE
;
; The slot becomes FREE and can be reused.
; ============================================================

remove_medicine:

    mov eax,msg_search
    call print_string

    call read_line

    call find_by_name

    cmp eax,-1
    je remove_not_found

    mov [current_index],eax

    mov ebx,eax


    ; Clear ID
    mov dword [medicine_ids+ebx*4],0

    ; Clear price
    mov dword [medicine_prices+ebx*4],0

    ; Clear stock
    mov dword [medicine_stocks+ebx*4],0

    ; Clear name
    call clear_name_slot


    mov eax,msg_removed
    call print_string

    call wait_enter

    jmp med_loop


remove_not_found:

    mov eax,msg_not_found
    call print_string

    call wait_enter

    jmp med_loop


; ============================================================
; INVENTORY MANAGEMENT
; ============================================================

inventory_management:

inv_loop:

    mov eax,inv_menu
    call print_string

    call read_number

    cmp eax,1
    je view_stock

    cmp eax,2
    je low_stock_check

    cmp eax,3
    je restock_medicine

    cmp eax,4
    je main_loop

    mov eax,msg_invalid
    call print_string

    call wait_enter

    jmp inv_loop


; ============================================================
; VIEW STOCK
; ============================================================

view_stock:

    mov ecx,0


stock_loop:

    cmp ecx,10
    jge stock_done

    cmp dword [medicine_ids+ecx*4],0
    je stock_next

    mov [current_index],ecx

    call display_medicine


stock_next:

    inc ecx

    jmp stock_loop


stock_done:

    call wait_enter

    jmp inv_loop


; ============================================================
; LOW STOCK CHECK
;
; Stock <= 10 = LOW STOCK
; Stock > 10 = OK
; ============================================================

low_stock_check:

    mov ecx,0


low_loop:

    cmp ecx,10
    jge low_done

    cmp dword [medicine_ids+ecx*4],0
    je low_next

    mov [current_index],ecx

    call display_medicine

    mov eax,[medicine_stocks+ecx*4]

    cmp eax,10
    jle show_low_status


    ; Stock is OK

    mov eax,msg_ok
    call print_string

    call print_newline

    jmp low_next


show_low_status:

    mov eax,msg_low
    call print_string

    call print_newline


low_next:

    inc ecx

    jmp low_loop


low_done:

    call wait_enter

    jmp inv_loop


; ============================================================
; RESTOCK MEDICINE
; ============================================================

restock_medicine:

    mov eax,msg_restock
    call print_string

    call read_line

    call find_by_name

    cmp eax,-1
    je restock_not_found

    mov [current_index],eax


restock_quantity:

    mov eax,msg_qty
    call print_string

    call read_number

    cmp eax,0
    jle restock_quantity

    mov ebx,[current_index]

    add [medicine_stocks+ebx*4],eax

    mov eax,msg_updated
    call print_string

    call wait_enter

    jmp inv_loop


restock_not_found:

    mov eax,msg_not_found
    call print_string

    call wait_enter

    jmp inv_loop


; ============================================================
; PROCESS SALE
;
; Multiple medicines can be added.
;
; IMPORTANT:
; Stock is RESERVED logically during the sale.
; Actual stock is reduced only after payment succeeds.
;
; Discount:
; If quantity of ONE medicine >= 5,
; that medicine receives 10% discount.
; ============================================================

process_sale:

    ; Reset current sale

    mov dword [cart_count],0

    mov dword [sale_subtotal],0

    mov dword [sale_discount],0

    mov dword [sale_items],0

    mov dword [sale_total],0

    mov dword [sale_change],0


sale_item_loop:

    mov eax,msg_sale_name
    call print_string

    call read_line

    call find_by_name

    cmp eax,-1
    je sale_not_found

    mov [current_index],eax


    ; --------------------------------------------------------
    ; Check cart capacity
    ; --------------------------------------------------------

    mov eax,[cart_count]

    cmp eax,10
    jge sale_cart_full


    ; --------------------------------------------------------
    ; Check permanent stock
    ; --------------------------------------------------------

    mov ebx,[current_index]

    mov eax,[medicine_stocks+ebx*4]

    cmp eax,0
    jle sale_out_of_stock


    ; --------------------------------------------------------
    ; Get quantity
    ; --------------------------------------------------------

    mov eax,msg_sale_qty
    call print_string

    call read_number

    cmp eax,0
    jle sale_bad_quantity

    mov esi,eax


    ; --------------------------------------------------------
    ; Calculate quantity already reserved
    ; for this medicine in current cart.
    ; --------------------------------------------------------

    mov ebx,[current_index]

    mov eax,[medicine_stocks+ebx*4]

    push eax

    call get_reserved_quantity

    mov edx,eax

    pop eax


    ; EAX = permanent stock
    ; EDX = already reserved quantity

    sub eax,edx

    ; EAX = remaining available stock

    cmp esi,eax
    jg sale_out_of_stock


    ; --------------------------------------------------------
    ; Calculate gross price
    ;
    ; price × quantity
    ; --------------------------------------------------------

    mov ebx,[current_index]

    mov eax,[medicine_prices+ebx*4]

    imul eax,esi

    ; Save gross price in EDX
    mov edx,eax


    ; --------------------------------------------------------
    ; QUANTITY-BASED DISCOUNT
    ;
    ; 5 or more units of the SAME medicine
    ; receive 10% discount.
    ; --------------------------------------------------------

    xor ebp,ebp

    cmp esi,5
    jl no_item_discount


    ; discount = gross × 10 / 100

    mov eax,edx

    mov ecx,10

    imul eax,ecx

    mov ecx,100

    xor edx,edx

    div ecx

    mov ebp,eax


    ; Calculate net item price

    mov ebx,[current_index]

    mov eax,[medicine_prices+ebx*4]

    imul eax,esi

    sub eax,ebp

    jmp store_sale_item


no_item_discount:

    mov ebx,[current_index]

    mov eax,[medicine_prices+ebx*4]

    imul eax,esi


; ============================================================
; STORE SALE ITEM
; ============================================================

store_sale_item:

    mov edi,[cart_count]


    ; Store medicine index
    mov edx,[current_index]

    mov [cart_index+edi*4],edx


    ; Store quantity
    mov [cart_qty+edi*4],esi


    ; Store calculated item total
    mov [cart_total+edi*4],eax


    ; Store reservation amount
    mov [cart_reserved+edi*4],esi


    ; Increase cart count
    inc dword [cart_count]


    ; Add item total to subtotal
    add [sale_subtotal],eax


    ; Add item discount
    add [sale_discount],ebp


    ; Add item quantity
    add [sale_items],esi


    ; --------------------------------------------------------
    ; Ask whether to add another medicine
    ; --------------------------------------------------------

    mov eax,msg_more
    call print_string

    call read_number

    cmp eax,1
    je sale_item_loop

    jmp sale_checkout


sale_not_found:

    mov eax,msg_not_found
    call print_string

    jmp sale_item_loop


sale_out_of_stock:

    mov eax,msg_insufficient
    call print_string

    jmp sale_item_loop


sale_bad_quantity:

    mov eax,msg_invalid_qty
    call print_string

    jmp sale_item_loop


sale_cart_full:

    mov eax,msg_cart_full
    call print_string

    jmp sale_checkout


; ============================================================
; SALE CHECKOUT
; ============================================================

sale_checkout:

    cmp dword [cart_count],0
    je sale_cancel


    ; --------------------------------------------------------
    ; Display subtotal
    ; --------------------------------------------------------

    mov eax,msg_subtotal
    call print_string

    mov eax,[sale_subtotal]
    call print_number

    call print_newline


    ; --------------------------------------------------------
    ; Display discount
    ; --------------------------------------------------------

    mov eax,msg_discount
    call print_string

    mov eax,[sale_discount]
    call print_number

    call print_newline


    ; --------------------------------------------------------
    ; Calculate final total
    ;
    ; total = subtotal - discount
    ; --------------------------------------------------------

    mov eax,[sale_subtotal]

    sub eax,[sale_discount]

    mov [sale_total],eax


    mov eax,msg_total
    call print_string

    mov eax,[sale_total]
    call print_number

    call print_newline


; ============================================================
; PAYMENT
; ============================================================

payment_loop:

    mov eax,msg_payment
    call print_string

    call read_number

    mov ebx,[sale_total]

    cmp eax,ebx
    jl payment_too_low


    ; Change = payment - total

    sub eax,ebx

    mov [sale_change],eax


    ; ========================================================
    ; PAYMENT SUCCESSFUL
    ;
    ; NOW REDUCE REAL STOCK.
    ; ========================================================

    mov ecx,0


update_cart:

    cmp ecx,[cart_count]
    jge update_summary


    ; Get medicine index
    mov edx,[cart_index+ecx*4]


    ; Get purchased quantity
    mov eax,[cart_qty+ecx*4]


    ; Reduce real stock
    sub [medicine_stocks+edx*4],eax


    inc ecx

    jmp update_cart


; ============================================================
; UPDATE SALES SUMMARY
; ============================================================

update_summary:

    ; Increase completed sales
    inc dword [total_sales]


    ; Add revenue
    mov eax,[sale_total]

    add [total_revenue],eax


    ; Add number of items sold
    mov eax,[sale_items]

    add [total_items_sold],eax


    ; Add discount
    mov eax,[sale_discount]

    add [total_discount_given],eax


    ; --------------------------------------------------------
    ; Display change
    ; --------------------------------------------------------

    mov eax,msg_change
    call print_string

    mov eax,[sale_change]
    call print_number

    call print_newline


    mov eax,msg_sale_done
    call print_string

    call wait_enter

    jmp main_loop


payment_too_low:

    mov eax,msg_payment_low
    call print_string

    jmp payment_loop


sale_cancel:

    mov eax,msg_cancel
    call print_string

    call wait_enter

    jmp main_loop


; ============================================================
; SALES SUMMARY
; ============================================================

sales_summary:

    mov eax,msg_total_sales
    call print_string

    mov eax,[total_sales]
    call print_number

    call print_newline


    mov eax,msg_revenue
    call print_string

    mov eax,[total_revenue]
    call print_number

    call print_newline


    mov eax,msg_items_sold
    call print_string

    mov eax,[total_items_sold]
    call print_number

    call print_newline


    mov eax,msg_total_discount
    call print_string

    mov eax,[total_discount_given]
    call print_number

    call print_newline


    call wait_enter

    jmp main_loop


; ============================================================
; GET RESERVED QUANTITY
;
; Searches current cart for the same medicine.
;
; Input:
; [current_index] = medicine being purchased
;
; Returns:
; EAX = total quantity already reserved
;
; Example:
;
; Stock = 5
; First purchase = 3
;
; Reserved = 3
;
; Second purchase:
; Available = 5 - 3 = 2
;
; Requesting 3 is rejected.
; ============================================================

get_reserved_quantity:

    push ebx
    push ecx
    push edx

    xor eax,eax

    mov ecx,0


reserved_loop:

    cmp ecx,[cart_count]
    jge reserved_done


    ; Get medicine index stored in cart

    mov ebx,[cart_index+ecx*4]


    ; Compare with current medicine

    cmp ebx,[current_index]
    jne reserved_next


    ; Same medicine found

    mov edx,[cart_qty+ecx*4]

    add eax,edx


reserved_next:

    inc ecx

    jmp reserved_loop


reserved_done:

    pop edx
    pop ecx
    pop ebx

    ret


; ============================================================
; FIND FIRST FREE MEDICINE SLOT
;
; Returns:
; EAX = free slot index
;
; EAX = -1 if all 10 slots are occupied
; ============================================================

find_free_slot:

    push ebx

    mov ebx,0


find_free_loop:

    cmp ebx,10
    jge no_free_slot


    ; ID 0 means FREE

    cmp dword [medicine_ids+ebx*4],0

    je free_slot_found


    inc ebx

    jmp find_free_loop


free_slot_found:

    mov eax,ebx

    pop ebx

    ret


no_free_slot:

    mov eax,-1

    pop ebx

    ret


; ============================================================
; FIND MEDICINE BY NAME
;
; Input:
; input buffer contains medicine name
;
; Returns:
; EAX = medicine index
;
; EAX = -1 if not found
; ============================================================

find_by_name:

    push ebx
    push ecx
    push edx

    mov ebx,0


find_name_loop:

    cmp ebx,10
    jge name_not_found


    ; Skip free slots

    cmp dword [medicine_ids+ebx*4],0
    je find_name_next


    mov eax,ebx

    call compare_input_with_slot

    cmp eax,1
    je name_found


find_name_next:

    inc ebx

    jmp find_name_loop


name_found:

    mov eax,ebx

    pop edx
    pop ecx
    pop ebx

    ret


name_not_found:

    mov eax,-1

    pop edx
    pop ecx
    pop ebx

    ret


; ============================================================
; COMPARE INPUT NAME WITH MEDICINE NAME
;
; Input:
; EAX = medicine index
;
; Returns:
; EAX = 1 if names match
; EAX = 0 if names are different
; ============================================================

compare_input_with_slot:

    push esi
    push edi
    push ebx
    push edx

    mov ebx,eax


    ; ESI = input buffer

    mov esi,input


    ; EDI = medicine_names + index*20

    mov edi,medicine_names

    imul ebx,20

    add edi,ebx


compare_loop:

    mov al,[esi]

    mov dl,[edi]

    cmp al,dl
    jne names_different

    cmp al,0
    je names_same

    inc esi

    inc edi

    jmp compare_loop


names_same:

    mov eax,1

    pop edx
    pop ebx
    pop edi
    pop esi

    ret


names_different:

    xor eax,eax

    pop edx
    pop ebx
    pop edi
    pop esi

    ret


; ============================================================
; DISPLAY MEDICINE
;
; Uses:
; [current_index]
; ============================================================

display_medicine:

    push eax
    push ebx
    push ecx


    mov ebx,[current_index]


    ; --------------------------------------------------------
    ; ID
    ; --------------------------------------------------------

    mov eax,msg_id_label
    call print_string

    mov eax,[medicine_ids+ebx*4]
    call print_number

    call print_newline


    ; --------------------------------------------------------
    ; NAME
    ; --------------------------------------------------------

    mov eax,msg_name_label
    call print_string


    mov eax,medicine_names

    mov ecx,ebx

    imul ecx,20

    add eax,ecx

    call print_string

    call print_newline


    ; --------------------------------------------------------
    ; PRICE
    ; --------------------------------------------------------

    mov eax,msg_price_label
    call print_string

    mov eax,[medicine_prices+ebx*4]

    call print_number

    call print_newline


    ; --------------------------------------------------------
    ; STOCK
    ; --------------------------------------------------------

    mov eax,msg_stock_label
    call print_string

    mov eax,[medicine_stocks+ebx*4]

    call print_number

    call print_newline


    pop ecx
    pop ebx
    pop eax

    ret


; ============================================================
; CLEAR MEDICINE NAME SLOT
; ============================================================

clear_name_slot:

    push eax
    push ebx
    push ecx
    push edi


    mov ebx,[current_index]

    mov edi,medicine_names

    imul ebx,20

    add edi,ebx

    mov ecx,20


clear_name_loop:

    mov byte [edi],0

    inc edi

    loop clear_name_loop


    pop edi
    pop ecx
    pop ebx
    pop eax

    ret


; ============================================================
; COPY INPUT INTO MEDICINE NAME SLOT
;
; Input:
; EAX = medicine slot index
;
; Maximum 19 characters.
; ============================================================

copy_input_to_name:

    push eax
    push ebx
    push ecx
    push esi
    push edi


    mov ebx,eax


    ; Calculate destination

    mov edi,medicine_names

    imul ebx,20

    add edi,ebx


    ; Clear slot

    mov ecx,20


copy_clear_loop:

    mov byte [edi],0

    inc edi

    loop copy_clear_loop


    ; Calculate destination again

    mov ebx,eax

    mov edi,medicine_names

    imul ebx,20

    add edi,ebx


    mov esi,input

    ; Maximum 19 characters

    mov ecx,19


copy_name_loop:

    mov al,[esi]

    cmp al,0
    je copy_name_done

    mov [edi],al

    inc esi

    inc edi

    loop copy_name_loop


copy_name_done:

    mov byte [edi],0


    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax

    ret


; ============================================================
; PRINT STRING
;
; Input:
; EAX = address of null-terminated string
; ============================================================

print_string:

    push eax
    push ebx
    push ecx
    push edx


    mov ecx,eax

    xor edx,edx


print_string_length:

    cmp byte [ecx+edx],0

    je print_string_write

    inc edx

    jmp print_string_length


print_string_write:

    mov eax,4

    mov ebx,1

    int 0x80


    pop edx
    pop ecx
    pop ebx
    pop eax

    ret


; ============================================================
; PRINT NEWLINE
; ============================================================

print_newline:

    mov eax,newline

    call print_string

    ret


; ============================================================
; READ LINE
;
; Reads keyboard input into input buffer.
; Removes newline character.
; ============================================================

read_line:

    push eax
    push ebx
    push ecx
    push edx
    push edi


    mov eax,3

    mov ebx,0

    mov ecx,input

    mov edx,63

    int 0x80


    ; EAX = number of bytes read

    mov edi,input

    mov ecx,eax

    cmp ecx,0
    jle read_empty


read_find_newline:

    cmp byte [edi],10
    je read_terminate

    cmp byte [edi],13
    je read_terminate

    inc edi

    loop read_find_newline


    ; No newline found

    mov byte [input+63],0

    jmp read_done


read_terminate:

    mov byte [edi],0

    jmp read_done


read_empty:

    mov byte [input],0


read_done:

    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret


; ============================================================
; READ NUMBER
; ============================================================

read_number:

    call read_line

    call atoi

    ret


; ============================================================
; ASCII TO INTEGER
;
; Converts decimal ASCII input into an integer.
;
; Example:
;
; "123"
;
; becomes:
;
; 123
; ============================================================

atoi:

    push ebx
    push ecx
    push edx
    push esi


    mov esi,input

    xor eax,eax

    xor ebx,ebx


atoi_loop:

    mov bl,[esi]

    cmp bl,0
    je atoi_done


    ; Validate digit

    cmp bl,'0'
    jb atoi_bad

    cmp bl,'9'
    ja atoi_bad


    ; Convert ASCII to digit

    sub bl,'0'


    ; result = result × 10 + digit

    imul eax,10

    add eax,ebx


    inc esi

    jmp atoi_loop


atoi_bad:

    xor eax,eax


atoi_done:

    pop esi
    pop edx
    pop ecx
    pop ebx

    ret


; ============================================================
; PRINT NUMBER
;
; Input:
; EAX = positive integer
; ============================================================

print_number:

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi


    cmp eax,0

    jne print_number_start


    mov eax,num_zero

    call print_string

    jmp print_number_done


print_number_start:

    mov edi,num_buffer+11

    mov byte [edi],0

    dec edi

    mov ebx,10


print_number_loop:

    xor edx,edx

    div ebx

    add dl,'0'

    mov [edi],dl

    dec edi

    cmp eax,0

    jne print_number_loop


    inc edi

    mov eax,edi

    call print_string


print_number_done:

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret


; ============================================================
; WAIT FOR ENTER
; ============================================================

wait_enter:

    push eax
    push ebx
    push ecx
    push edx


    mov eax,msg_press

    call print_string

    call read_line


    pop edx
    pop ecx
    pop ebx
    pop eax

    ret


; ============================================================
; EXIT PROGRAM
; ============================================================

exit_program:

    mov eax,1

    xor ebx,ebx

    int 0x80
