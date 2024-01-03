format ELF64 executable

include "syscall.inc"
include "string.inc"
include "utils.inc"

MAX_CONN    equ 10

segment writeable executable
entry main

main:
    ; Creating Socket
    socket AF_INET, SOCK_STREAM, 0
    cmp     rax, 0
    jl      .error
    mov     [sockfd], rax

    mov     rdi, STDOUT
    mov     rsi, createSocket
    call    write_cstr

    mov     word [servaddr.sin_family], AF_INET
    mov     dword [servaddr.sin_addr], INADDR_ANY
    mov     word [servaddr.sin_port], 14619

    ; Binding Socket
    bind    [sockfd], servaddr.sin_family, servaddrLen
    cmp     rax, 0
    jl      .error

    mov     rdi, STDOUT
    mov     rsi, bindingSocket
    call    write_cstr

    ; Listening Socket
    mov     rdi, STDOUT
    mov     rsi, listeningSocket
    call    write_cstr

    listen  [sockfd], MAX_CONN
    cmp     rax, 0
    jl      .error

    ; Accept Client to Connect
    accept  [sockfd], cliaddr.sin_family, cliaddrLen
    cmp     rax, 0
    jl      .error

    mov     [connfd], rax

    ; Send Greeting Message to Client
    mov     rdi, [connfd]
    mov     rsi, greetingMsg
    call    write_cstr

    close   [connfd]
    close   [sockfd]

    exit    EXIT_SUCCESS

.error:
    mov     rdi, STDERR
    mov     rsi, serverErrorMsg
    call    write_cstr

    close   [connfd]
    close   [sockfd]

    exit    EXIT_FAILURE

segment writeable readable

sockfd  dq -1
connfd  dq -1

struc sockaddr_in
{
    .sin_family dw 0
    .sin_port   dw 0
    .sin_addr   dd 0
    .sin_zero   dq 0
}

servaddr sockaddr_in
servaddrLen = $ - servaddr.sin_family

cliaddr sockaddr_in
cliaddrLen dd servaddrLen

createSocket db "[INFO] Creating Socket...", 10, 0
bindingSocket db "[INFO] Binding Socket...", 10, 0
listeningSocket db "[INFO] Listening Socket...", 10, 0
serverErrorMsg db "[ERROR] Server Error...", 10, 0

greetingMsg db "@Server > Hello From Server", 10, 0
