format ELF64 executable

include "syscall.inc"
include "string.inc"
include "inet.inc"
include "utils.inc"

MAX_CONN    equ 10

segment writeable executable
entry main

main:

    pop     rdi ; argc
    cmp     rdi, 3
    jne     .exit_usage

    pop     rsi ; argv[0]

    pop     rdi ; argv[1]
    call    stoi
    mov     dword [ipv4], eax
    ; TODO - inet_addr()

    pop     rdi ; argv[2]
    call    stoi
    mov     rdi, rax
    call    htons
    mov     word [port], ax

    ; Creating Socket
    socket AF_INET, SOCK_STREAM, 0
    cmp     eax, 0
    jl      .error

    mov     dword [sockfd], eax

    mov     rdi, STDOUT
    mov     rsi, createSocket
    call    write_cstr

    mov     word    [servaddr.sin_family], AF_INET
    mov     dword   [servaddr.sin_addr], INADDR_ANY

    mov     ax, word [port]
    mov     word    [servaddr.sin_port], ax

    ; Binding Socket
    bind    dword [sockfd], servaddr.sin_family, servaddrLen
    cmp     rax, 0
    jl      .error

    mov     rdi, STDOUT
    mov     rsi, bindingSocket
    call    write_cstr

    ; Listening Socket
    mov     rdi, STDOUT
    mov     rsi, listeningSocket
    call    write_cstr

    listen  dword [sockfd], MAX_CONN
    cmp     rax, 0
    jl      .error

    ; Accept Client to Connect
    accept  [sockfd], cliaddr.sin_family, cliaddrLen
    cmp     rax, 0
    jl      .error

    mov     dword [connfd], eax

    ; Send Greeting Message to Client
    mov     edi, dword [connfd]
    mov     rsi, greetingMsg
    call    write_cstr

    close   dword [connfd]
    close   dword [sockfd]

    exit    EXIT_SUCCESS

.error:
    mov     rdi, STDERR
    mov     rsi, serverErrorMsg
    call    write_cstr

    close   dword [connfd]
    close   dword [sockfd]

    exit    EXIT_FAILURE

.exit_usage:
    mov     rdi, STDERR
    mov     rsi, usageMsg
    call    write_cstr

    exit    EXIT_FAILURE

segment writeable readable

ipv4    dd 0
port    dw 0

sockfd  dd -1
connfd  dd -1

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
usageMsg db "Usage: server [IPV4] [PORT]", 10, 0

