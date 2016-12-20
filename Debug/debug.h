#ifndef __DEBUG_H__
#define __DEBUG_H__

#define print(val)
	printf("%s = %ul",(#val),val)
		
#define DEBUG_OUTPUT(format,...)\
	printf(format"FILE:%s    FUNCTION:%s    LINE:%u\n", __VA_ARGS__,__FILE__,__FUNCTION__,__LINE__)		

#endif
