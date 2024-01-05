format ELF64 executable

include "syscall.inc"
include "string.inc"
include "inet.inc"
include "utils.inc"

segment writeable executable
entry main

main:
    ; Creating Socket
    socket  AF_INET, SOCK_STREAM, 0
    cmp     rax, 0
    jl      .error

    mov     dword [sockfd], eax

    mov     rdi, STDOUT
    mov     rsi, createSocket
    call    write_cstr

    mov     word [cliaddr.sin_family], AF_INET
    mov     dword [cliaddr.sin_addr], INADDR_ANY

    mov     rdi, port
    call    htons
    mov     word [cliaddr.sin_port], ax

    connect dword [sockfd], cliaddr, cliaddrLen
    cmp     rax, 0
    jl      .error

    mov     rdi, STDOUT
    mov     rsi, connectSocket
    call    write_cstr

    close   dword [sockfd]
    exit    EXIT_SUCCESS

.error:
    mov     rdi, STDERR
    mov     rsi, clientErrorMsg
    call    write_cstr

    close   dword [sockfd]
    exit    EXIT_FAILURE

segment writeable readable

port    dw 6969
sockfd  dq 0

struc sockaddr_in
{
    .sin_family dw 0
    .sin_port   dw 0
    .sin_addr   dd 0
    .sin_zero   dq 0
}

cliaddr sockaddr_in
cliaddrLen = $ - cliaddr

createSocket db "[INFO] Creating Socket...", 10, 0
connectSocket db "[INFO] Connected to Server...", 10, 0
clientErrorMsg db "[ERROR] Client Error...", 10, 0

