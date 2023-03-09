; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$" 
    message_1 db "Entrez le premier operande  $"
    message_2 db "Entrez la deuxieme operande  $"
    message_3 db "La somme est >   $"
    test_ db "vous avez appuiez sur entrer $"
    i db 1 
    op1 dw ?
    op2 dw ?
    dix dw 10
    cent dw 100
    mille dw 1000
    dix_mille dw 10000
    factor dw 10 
    result dw ?
    
    
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax 
    xor ax,ax
    
    
          
                 mov dl, offset message_1
                 mov ah, 9
                 int 21H
                 mov dl,0
         scan_1: mov ah, 1
                 int 21H ; code asci de la valuer saisie dans al
                 cmp al, 0DH
                 jne push_value_1 
                 jmp next_scan_1
   push_value_1: xor ah,ah
                 push ax
                 inc dl 
                 loop scan_1
                 
    next_scan_1: mov cl,dl
                 xor bx,bx
                 mov bx,1
                 ;______________________________________; 
                 pop ax
                 sub ax,30H
                 xor ah,ah
                 mov op1,ax
                 dec cl
                 
                 
     add_loop_1: mov ax, bx
                 mul factor ;resultat dans DX:AX
                 mov bx,ax
                 pop ax
                 sub ax,30H 
                 xor ah,ah
                 mul bx
                 add op1,ax
                 cmp cl,1
                 je scan_op2
                 
                 dec cl
             jmp add_loop_1 
                 
       scan_op2: call return
                 mov dl, offset message_2
                 mov ah, 9
                 int 21H 
                 mov dl,0
         scan_2: mov ah, 1
                 int 21H ; code asci de la valuer saisie dans al
                 cmp al, 0DH
                 jne push_value_2 
                 jmp next_scan_2
   push_value_2: xor ah,ah
                 push ax
                 inc dl 
                 loop scan_2
                 
    next_scan_2: mov cl,dl
                 xor bx,bx
                 mov bx,1
                 ;______________________________________; 
                 pop ax
                 sub ax,30H
                 xor ah,ah
                 mov op2,ax
                 dec cl
                 
                 
     add_loop_2: mov ax, bx
                 mul factor ;resultat dans DX:AX
                 mov bx,ax
                 pop ax
                 sub ax,30H 
                 xor ah,ah
                 mul bx
                 add op2,ax
                 cmp cl,1
                 je somme 
                 
                 dec cl
             jmp add_loop_2 
       
     

     somme: call return
            mov dl, offset message_3
            mov ah, 9
            int 21H
            mov ax,op1
            add ax,op2
            mov result, ax
            xor dx,dx
            ;______________________________________;
            div dix_mille
            mov cx,dx
            mov ah,2
            mov dx,ax
            add dx,30H
            int 21H  
            ;______________________________________; 
            xor dx,dx
            mov ax,cx
            div mille
            mov cx,dx
            mov ah,2
            mov dx,ax
            add dx,30H
            int 21H
            ;______________________________________;
            xor dx,dx
            mov ax,cx
            div cent
            mov cx,dx
            mov ah,2
            mov dx,ax
            add dx,30H
            int 21H
            ;______________________________________;
            xor dx,dx
            mov ax,cx
            div dix
            mov cx,dx
            mov ah,2
            mov dx,ax
            add dx,30H
            int 21H
            ;______________________________________;
            mov ah,2
            mov dx,cx
            add dx,30H
            int 21H
            ;______________________________________;
            
             
         
                  
            
            
               
             
            
             
            
             
            
            
                     
               
hlt
                      return proc
    
                           ;;;;;;;;;;;;;;;;;;;;;;;;;;; 
	                       mov ah, 2
	                       mov dl, 0AH
	                       int 21h
	
	                       mov ah, 2
	                       mov dl, 13
	                       int 21h 
	                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
                        ret
                      return endp            
             
          
   
ends

end start ; set entry point and stop the assembler.
