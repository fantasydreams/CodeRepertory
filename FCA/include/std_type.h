#ifndef __STD_TYPE__
#define __STD_TYPE__

#ifdef __LP64__
#define UINTPTR_SIZE 64
#else
#ifdef __ILP32__
#define UINTPTR_SIZE 32
#else
#error "please specify LP64 or ILP32"
#endif
#endif


#define VOID void

#define UINT8   unsigned char
#define UINT16  unsigned short
#define UINT32  unsigned int
#define UINT64  unsigned long long

#define SINT8   signed char
#define SINT16  signed short
#define SINT32  signed int
#define SINT64  signed long long

#if   (32 == UINTPTR_SIZE)
#define UINTPTR UINT32
#elif (64 == UINTPTR_SIZE)
#define UINTPTR UINT64
#endif

#define IN
#define OUT
#define INOUT
	

#endif
