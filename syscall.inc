SYS_read    equ 0
SYS_write   equ 1
SYS_close   equ 3
SYS_socket  equ 41
SYS_connect equ 42
SYS_accept  equ 43
SYS_bind    equ 49
SYS_listen  equ 50
SYS_exit    equ 60

EXIT_SUCCESS    equ 0
EXIT_FAILURE    equ 1

STDIN       equ 0
STDOUT      equ 1
STDERR      equ 2

INADDR_ANY  equ 0
SOCK_STREAM equ 1
AF_INET     equ 2

macro write fd, buf, count
{
    mov     rax, SYS_write
    mov     rdi, fd
    mov     rsi, buf
    mov     rdx, count
    syscall
}

macro close fd
{
    mov     rax, SYS_close
    mov     edi, fd
    syscall
}
; int socket(int domain, int type, int protocol);
macro socket domain, type, protocol
{
    mov     rax, SYS_socket
    mov     edi, domain
    mov     esi, type
    mov     edx, protocol
    syscall
}

macro connect fd, addr, addrlen
{
    mov     rax, SYS_connect
    mov     edi, fd
    mov     rsi, addr
    mov     rdx, addrlen
    syscall
}

macro accept sockfd, addr, addrlen
{
    mov     rax, SYS_accept
    mov     edi, sockfd
    mov     rsi, addr
    mov     rdx, addrlen
    syscall
}

macro bind sockfd, addr, addrlen
{
    mov     rax, SYS_bind
    mov     edi, sockfd
    mov     rsi, addr
    mov     rdx, addrlen
    syscall
}

macro listen sockfd, backlog
{
    mov     rax, SYS_listen
    mov     edi, sockfd
    mov     rsi, backlog
    syscall
}

macro exit exit_code
{
    mov     rax, SYS_exit
    mov     rdi, exit_code
    syscall
}
