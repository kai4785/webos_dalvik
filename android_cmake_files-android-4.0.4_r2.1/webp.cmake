# Copyright 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#I didn't like the way the Android.mk files were spread out, so we have just one here

set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/src/enc)

CLEAR_VARS()
set(LOCAL_SRC_FILES
	${LOCAL_PATH}/alpha.c 
	${LOCAL_PATH}/analysis.c 
	${LOCAL_PATH}/bit_writer.c 
	${LOCAL_PATH}/config.c 
	${LOCAL_PATH}/cost.c 
	${LOCAL_PATH}/dsp.c 
	${LOCAL_PATH}/dsp_sse2.c 
	${LOCAL_PATH}/filter.c 
	${LOCAL_PATH}/frame.c 
	${LOCAL_PATH}/iterator.c 
	${LOCAL_PATH}/layer.c 
	${LOCAL_PATH}/picture.c 
	${LOCAL_PATH}/quant.c 
	${LOCAL_PATH}/syntax.c 
	${LOCAL_PATH}/tree.c 
	${LOCAL_PATH}/webpenc.c
    )

set(LOCAL_CFLAGS -DANDROID)

concat(LOCAL_C_INCLUDES
	${LOCAL_PATH} 
	${LOCAL_PATH}/../../include
)

set(LOCAL_MODULE webp-encode)

BUILD_STATIC_LIBRARY()

set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/src/dec)

CLEAR_VARS()
set(LOCAL_SRC_FILES
	${LOCAL_PATH}/alpha.c 
	${LOCAL_PATH}/bits.c 
	${LOCAL_PATH}/buffer.c 
	${LOCAL_PATH}/dsp.c 
	${LOCAL_PATH}/dsp_sse2.c 
	${LOCAL_PATH}/frame.c 
	${LOCAL_PATH}/idec.c 
	${LOCAL_PATH}/io.c 
	${LOCAL_PATH}/io_sse2.c 
	${LOCAL_PATH}/layer.c 
	${LOCAL_PATH}/quant.c 
	${LOCAL_PATH}/tree.c 
	${LOCAL_PATH}/vp8.c 
	${LOCAL_PATH}/webp.c 
	${LOCAL_PATH}/yuv.c
    )

set(LOCAL_CFLAGS  -DANDROID)

concat(LOCAL_C_INCLUDES
	${LOCAL_PATH} 
	${LOCAL_PATH}/../../include
    )

set(LOCAL_MODULE webp-decode)

BUILD_STATIC_LIBRARY()
