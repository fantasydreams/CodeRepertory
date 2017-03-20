#ifndef __QUEUE_TEST__
#define __QUEUE_TEST__
#ifdef __cplusplus

#include "fca_type.h"
#include <gtest/gtest.h>
#include "queue.h"



extern "C"
{
#endif



TEST(QueueTest, singleThreadInputAndOutput)
{
#define MAX (256)
	queue<FCA_U32> que(MAX);
	FCA_U32 IndexLoop = 0;
	while (IndexLoop < MAX + 6)
	{
		que.push(IndexLoop);
		++IndexLoop;
	}
	EXPECT_EQ(MAX - 1, que.get_size());
	EXPECT_EQ(FCA_TRUE, que.is_full());
	EXPECT_FALSE(que.is_empty());
	FCA_U32 value;
	EXPECT_EQ(FCA_TRUE,que.pop(&value));
	EXPECT_EQ(FCA_FALSE, que.is_full());
	while (!que.is_empty())
	{
		que.pop(&value);
	}
	EXPECT_EQ(0, que.get_size());

#undef MAX
}

#ifdef __cplusplus
}
#endif
#endif