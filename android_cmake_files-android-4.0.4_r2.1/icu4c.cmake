# Copyright (C) 2008 The Android Open Source Project
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

set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
CLEAR_VARS()

android_add_subdirectory(common)
android_add_subdirectory(i18n)
#android_include(icu4c_stubdata.cmake)

install(FILES stubdata/icudt46l-all.dat 
    DESTINATION icu
    RENAME icudt46l.dat
    )
