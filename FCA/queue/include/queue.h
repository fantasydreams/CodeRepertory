#include "fca_type.h"

#ifndef __QUEUE_H__
#define __QUEUE_H__

const FCA_ULONG g_quque_default_capasity = 4096;

template <class Any>
class queue
{
public:
    queue(FCA_ULONG capacity = g_quque_default_capasity);
    ~queue();
    
    FCA_BOOL pop(Any *);
    FCA_BOOL push(Any);
    FCA_BOOL is_empty();
    FCA_BOOL is_full();
    FCA_ULONG get_size();
    
private:
    queue(queue<Any> &){};
    queue<Any>& operator=(queue<Any> &);
    
    FCA_ULONG m_capasity;
    FCA_ULONG m_front;
    FCA_ULONG m_rear;
    Any *m_queue_ptr;
};



template <class Any>
inline queue<Any>::queue(FCA_ULONG capacity = g_quque_default_capasity):m_capasity(capacity),m_queue_ptr(FCA_NULL),\
                        m_front(0),m_rear(0)
{
    m_capasity = (0 == m_capasity)?g_quque_default_capasity:m_capasity;
    m_queue_ptr = new Any[m_capasity];
}


template <class Any>
inline queue<Any>::~queue()
{
    delete[] m_queue_ptr;
}


template <class Any>
inline FCA_BOOL queue<Any>::pop(Any *elem)
{
    ASSERT(!is_empty());
    *elem = m_queue_ptr[m_front];
    m_front = (m_front + 1) % m_capasity;
    return FCA_TRUE;
}


template <class Any>
inline FCA_BOOL queue<Any>::push(Any elem)
{
    ASSERT(!is_full());
    m_queue_ptr[m_rear] = elem;
    m_rear = (m_rear + 1) % m_capasity;
    return FCA_TRUE;
}

template <class Any>
inline FCA_ULONG queue<Any>::get_size()
{
    return (m_rear - m_front + m_capasity)%m_capasity;
}


template <class Any>
inline FCA_BOOL queue<Any>::is_empty()
{
    return (m_front == m_rear);
}

template <class Any>
inline FCA_BOOL queue<Any>::is_full()
{
    return (((m_rear + 1) % m_capasity) == m_front);
}

#endif
