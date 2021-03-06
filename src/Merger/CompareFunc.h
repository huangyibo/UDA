/*
** Copyright (C) 2012 Auburn University
** Copyright (C) 2012 Mellanox Technologies
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at:
**
** http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
** either express or implied. See the License for the specific language
** governing permissions and  limitations under the License.
**
**
*/

#ifndef __COMPARE_FUNC
#define __COMPARE_FUNC

#include "IOUtility.h"

typedef int (*hadoop_cmp_func)(char* key1, int len1, char* key2, int len2);

// compare function to be used during reducer mergeSort
// set once on init_reduce_task according to Java's reducer's comparator type name
extern hadoop_cmp_func g_cmp_func;

hadoop_cmp_func get_compare_func(const char* java_comparator_type_name);

#endif
