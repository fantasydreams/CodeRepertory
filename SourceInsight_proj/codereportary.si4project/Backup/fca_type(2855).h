#ifndef __STD_TYPE__
#define __STD_TYPE__

#ifdef __LP64__
#define FCAPTR_SIZE 64
#else
#ifdef __ILP32__
#define FCAPTR_SIZE 32
#else
#error "please specify LP64 or ILP32"
#endif
#endif

#define IN
#define OUT
#define INOUT


#define FCA_VOID void

#define FCA_U8   unsigned char
#define FCA_U16  unsigned short
#define FCA_U32  unsigned int
#define FCA_U64  unsigned long long

#define FCA_S8   signed char
#define FCA_S16  signed short
#define FCA_S32  signed int
#define FCA_S64  signed long long

#define FCA_INT  int
#define FCA_ULONG unsigned long

#if   (32 == UINTPTR_SIZE)
#define FCAPTR U32
#elif (64 == UINTPTR_SIZE)
#define FCAPTR U64
#endif


#ifdef __cplusplus
//#define FCA_NULL  std::nullptr
#define FCA_NULL  0
#define FCA_OK    true
#define FCA_FALUE false
#else
#define FCA_NULL  0
#define FCA_OK    0
#define FCA_FALUE 1
#endif

#ifdef __cplusplus
#define FCA_BOOL bool
#elif defined _Bool
#define FCA_BOOL _Bool
#else
#define FCA_BOOL FCA_INT
#endif



#endif
