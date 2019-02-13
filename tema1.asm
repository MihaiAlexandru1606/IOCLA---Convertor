%include "io.inc"

%define SIZE_DWORD    4
%define MIN_BASE      2
%define MAX_BASE      16

section .data
    %include "input.inc"
    base db "0123456789abcdef"
    error db "Baza incorecta", 0 ;  mseajul de eroare
    count dw 0      ;   contor pentru numarul de resturi
    
section .text
global CMAIN
CMAIN:
    ;	pastrarea adresei stivei pentru refacearea la finalul programului
    mov ebp, esp    
    ;	setrarea registrilor folositi pe 0 
    xor eax, eax;
    xor ebx, ebx;
    xor edx, edx;
    xor ecx, ecx;
    
Do_While_1:
    ;   ecx este folosoit ca si un index
    mov eax, dword [nums_array + SIZE_DWORD * ecx ];  echivalent cu nums_array[ecx]
    mov ebx, dword [base_array + SIZE_DWORD * ecx ];  echivalent cu base_array[ecx]
    
    ;   verificarea daca baza este valida, daca nu afisare mesajului de eroare
    cmp ebx, MIN_BASE
    jl print_error
    cmp ebx, MAX_BASE
    jg print_error
    
Do_While_impartire:
    ;   impartiri succesive pana cand impartitul ajunge 0
    ;   restul este pus in stiva, si incrementat contorul( count )
    ;   pentru fiecare impartire edx trebuie sa fie 0
    ; 	impartind la ebx( double word), deimpartitul este reprezentat edx:eax
       
    div ebx
    push edx ;          punarea restului pe stiva
    inc dword [count] ; incremantarea contorului
    xor edx, edx ;      impartitul este reprezenta edx:eax, edx trebui sa fie 0
    cmp eax, 0 ;        repetarea pana cand dempartitul a junge 0
    jnz Do_While_impartire
    
    
    ;	mutarea numarului de resturi obtrinute
    mov ebx, [count]
 print:
    ;	se execta de count ori secveta de cod
    ;	restul extras de pe stiva este pus in edx
    ;	pt fiecare valoare a restului se printeaza 'caraterul' corespunzator
    pop edx;
    mov al, [base + edx ] ;	  echivanet cu base[edx]
    PRINT_CHAR al
    dec ebx
    cmp ebx, 0
    jnz print
    NEWLINE
    

return_print_error:
    ;   restarea contorului pe 0
    xor edx, edx
    mov [count], edx
    ;	se repata de nums, pentru fiecare numar din vector
    mov ebx, [nums]
    inc ecx
    cmp ebx, ecx
    jnz Do_While_1
    
	
    mov esp, ebp   
    xor eax, eax
    ret
    
 
print_error:
    PRINT_STRING error;
    NEWLINE
    jmp return_print_error
