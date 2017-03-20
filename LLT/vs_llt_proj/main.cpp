#include <gtest/gtest.h>
#include "queuetest.h"


int main(int argc,wchar_t* argv[])
{
	testing::InitGoogleTest(&argc, argv);
	int ret = RUN_ALL_TESTS();
	getchar();
	return 0;
}