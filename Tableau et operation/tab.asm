
data segment
    ; add your data here!
    
    message_1 db "Entrer la taille du tableau $"
    message_2 db "Entrer la taille du tableau < 64 $" 
    tab_plot db "tab =  $" 
    la_moyenne db "La moyenne est $" 
    max db "Le maximum est $"
    min db "Le minimum est $" 
    croissant_message db "trie croissant $"
    sum db "la somme est $"
    decroissant_message db "trie decroissant $"
    tableau db dup(0) 
    taille db 0
    dix db 10
    un db 1
    one dw 1 
    moyenne db 0 
    maxi db ? 
    croissant db dup(0)
    decroissant db dup(0)
    
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
    xor ax, ax   
    
    
    
    mov ah, 9
    mov dl,offset message_2
    int 21H
    ;____________________________________;
    
    ;taille du tableau
scan:  mov ah,1
       int 21H; saisie stocker dans al 
       xor dx,dx
       mov dl,al
       sub dl,30H
       xor ah,ah
       mov al,dl
       mul dix 
       add taille,al
       
       mov ah,1
       int 21H; saisie stocker dans al 
       xor dx,dx
       mov dl,al
       sub dl,30H
       add taille,dl  
       
       mov al,taille
       
       
       
      
    call tab  
    ;____________________________________;
    
   ;;Remplissage du tableau
   
   mov bx, offset tableau 
   xor cx,cx
   mov cl,taille
   
   
   remplissage:
   
   mov ah,1
   int 21H; saisie stocker dans al
   mov tableau[bx],al 
   
   inc bx
   cmp cl,0
   jz plot
   loop remplissage 
   
   ;_________________________________;
   ;affichage du tableau 
   
 plot:  call return 
        call return
        mov ah, 9
        mov dl,offset tab_plot 
        int 21H
        xor cx,cx
        mov cl,taille 
        mov bx, offset tableau
 value_tab: mov ah,2
            mov dl,20H
            int 21H 
 
 
             mov ah,2 
             
             mov dl,tableau[bx]
             
             inc bx
             int 21H
             cmp cl,0
             jz suivant 
             loop value_tab 
   
   suivant: ;_______________________________________;
             ;la moyenne
                      call return
                      xor cx,cx
                      mov cl,taille
                      mov bx, offset tableau
                      xor ax,ax 
 moyenne_boucle:      
                      sub tableau[bx],30H
                      add al, tableau[bx]
                      mov moyenne,al
                      inc bx
                      cmp cl,0
                      jz plot_somme
                      loop moyenne_boucle 
                      
                      
  plot_somme:         call return
                       
                      mov ah,9
                      mov dl,offset sum  
                      int 21H
                      
                     
                      ;________________________________;
                      
                      xor ax,ax
                      mov al,moyenne
                      mov bl,dix
                      div bl ; Quotent dans al
                      mov bh,ah; on recupere le reste
                      mov ah,2 
                      add al,30H
                      mov dl,al
                      int 21H
                      mov ah,2
                      add bh,30h
                      mov dl,bh
                      int 21H
                      
                      call return
                      
                      ;________________________________;
                        
 result_moyenne:      call return
                      xor ah,ah
                      mov al, moyenne
                      div taille
                      mov moyenne,al
                      mov bl,ah; je recupere le reste
                      mov ah,9
                      mov dl, offset la_moyenne
                      int 21H
                      
                      mov ah,2
                      mov dl, moyenne 
                      add dl,30H
                      int 21H
                       
                      ;_________________________;
                      
                      mov ah,2
                      mov dl,02CH
                      int 21H
                      
                      ;_________________________;
                      mov cx,2
         decimal_part:xor ax,ax
                      mov al,bl         
                      mul dix 
                      div taille
                      mov bl,ah
                      mov ah,2
                      mov dl, al 
                      add dl,30H
                      int 21H 
                      cmp cx,0
                      jz trie
                      loop decimal_part
                      
        trie:         call return
                      mov dl,taille
                      xor ax,ax
                      mov bx,offset tableau
                      mov al,tableau[bx]
        max_loop:     inc bx
                      mov ah,tableau[bx] 
                      dec dl
                      cmp dl,0
                      jz plot_max:
                      cmp al,ah
                      jl maximum
                      loop max_loop               
        maximum:      mov al,ah
                      jmp max_loop 
                      
                      
        plot_max:     mov maxi,al
                      call return
                      mov ah, 9
                      mov dl,offset max
                      int 21H 
                      
                      mov ah,2
                      mov dl, maxi 
                      add dl,30H
                      int 21H 
                      
                      
        suite:        call return
                      mov dl,taille
                      xor ax,ax
                      mov bx,offset tableau
                      mov al,tableau[bx]
        min_loop:     inc bx
                      mov ah,tableau[bx] 
                      dec dl
                      cmp dl,0
                      jz plot_min:
                      cmp al,ah
                      jg minimum
                      loop min_loop               
        minimum:      mov al,ah
                      jmp min_loop 
                      
                      
        plot_min:     mov maxi,al
                      call return
                      mov ah, 9
                      mov dl,offset min
                      int 21H 
                      
                      mov ah,2
                      mov dl, maxi 
                      add dl,30H
                      int 21H 
                             
       ;_______________________________________; 
       
;On vas utiliser adressage base indexer pour les indice des boucles
             
             mov bx,offset tableau
             mov si,00H
             xor dx,dx
             mov dl,0
             mov dh,1
             
    boucle_1:xor cx,cx
             mov cl,taille
             mov al,tableau[bx]
             mov si,1
             inc dl
             inc dh
             cmp dl,taille
             je fin
             jmp boucle_2
             
    boucle_2:
             mov ah,tableau[bx + si]
             cmp al,ah
             jge permute
             jmp reboucle
              
    permute: mov tableau[bx + si],al
             mov tableau[bx],ah 
             mov al,ah
             jmp reboucle
    reboucle: 
              inc si
              cmp cl,dh
              je  boucle_1_inc
              loop boucle_2     
    
 boucle_1_inc:inc bx
              jmp boucle_1
              
                   
fin:    call return
        call return
        mov ah,9
        mov dx,offset croissant_message
        int 21H            
             ;affichage du tableau 
   
 plot_: xor ax,ax
        
        xor cx,cx
        mov cl,taille 
        mov bx, offset tableau
 value_tab_: mov ah,2
            mov dl,20H
            int 21H 
 
 
             mov ah,2 
             
             mov dl,tableau[bx]
             add dl,30H
             inc bx
             int 21H
             cmp cl,0
             jz suivant_ 
             loop value_tab_ 
   
   suivant_: ;_______________________________________;
   
   ;On vas utiliser adressage base indexer pour les indice des boucles
             
             mov bx,offset tableau
             mov si,00H
             xor dx,dx
             mov dl,0
             mov dh,1
             
    boucle_1_:xor cx,cx
             mov cl,taille
             mov al,tableau[bx]
             mov si,1
             inc dl
             inc dh
             cmp dl,taille
             je fin_
             jmp boucle_2_
             
    boucle_2_:
             mov ah,tableau[bx + si]
             cmp al,ah
             jle permute_
             jmp reboucle_
              
    permute_: mov tableau[bx + si],al
             mov tableau[bx],ah 
             mov al,ah
             jmp reboucle_
    reboucle_: 
              inc si
              cmp cl,dh
              je  boucle_1_inc_
              loop boucle_2_     
    
 boucle_1_inc_:inc bx
              jmp boucle_1_
              
                   
fin_:   call return
        call return
        mov ah,9
        mov dx,offset decroissant_message
        int 21H            
             ;affichage du tableau 
   
 plot__: xor ax,ax
        
        xor cx,cx
        mov cl,taille 
        mov bx, offset tableau
 value_tab__: mov ah,2
            mov dl,20H
            int 21H 
 
 
             mov ah,2 
             
             mov dl,tableau[bx]
             add dl,30H
             inc bx
             int 21H
             cmp cl,0
             jz suivant__ 
             loop value_tab__ 
   
   suivant__: ;_______________________________________;      

    
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
 tab proc 
    mov ah, 2
    mov dl,20H
    int 21H
    
    ret 
 tab endp
    
            
       
ends

end start 
