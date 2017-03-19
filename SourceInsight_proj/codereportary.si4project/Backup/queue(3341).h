#include "fca_type.h"

#ifndef __QUEUE__
#define __QUEUE__

template <class Any> class queue_impl;

template <class Any>
class queue
{
public:
    queue(FCA_ULONG max_capacity);
    ~queue();
    
    Any pop();
    FCA_BOOL push(Any);
    FCA_BOOL is_empty();
    
private:
    queue(queue<Any> &);
    queue<Any>& operator=(queue<Any> &);
    queue_impl<Any> *impl_ptr;
};

#endif