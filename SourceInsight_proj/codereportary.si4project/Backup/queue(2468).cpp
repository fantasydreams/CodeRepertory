#include "queue.h"

const FCA_ULONG g_quque_max_capasity = 4096;

template <class Any>
class queue_impl
{
    queue_impl(FCA_ULONG max_capasity);
    ~queue_impl();
    
    FCA_ULONG m_capasity;
    FCA_ULONG m_max_capasity;
    FCA_ULONG front;
    FCA_ULONG rear;
    Any *queue_ptr;
};


template <class Any>
inline queue_impl<Any>::queue_impl(FCA_ULONG max_capasity  = g_quque_max_capasity)\
                 :m_max_capasity(max_capasity),queue_ptr(FCA_NULL),front(0),rear(0)
{
    if(0 == m_max_capasity)
    {
        m_max_capasity = g_quque_max_capasity;
    }
    m_capasity = m_max_capasity/2;
    queue_ptr = new Any[m_capasity];
    
}


template <class Any>
inline queue_impl<Any>::~queue_impl()
{
    delete queue_ptr;
}


template <class Any>
inline queue<Any>::queue(queue<Any> &t){}


template <class Any>
inline queue<Any>& queue<Any>::operator=(queue<Any> &)
{
    queue<Any> a;
    return a;
}

template <class Any>
inline queue<Any>::queue(FCA_ULONG max_capacity):impl_ptr(FCA_NULL)
{
    impl_ptr = new queue_impl<Any>(max_capacity);
}


template <class Any>
inline queue<Any>::~queue()
{
    delete impl_ptr;
}


template <class Any>
inline Any queue<Any>::pop()
{
    Any a;
    return a;
}


template <class Any>
inline FCA_BOOL queue<Any>::push(Any elem)
{
    return true;
}