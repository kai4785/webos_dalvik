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

#
# Common definitions.
#

CLEAR_VARS()

set(src_files 
	ucln_in.c  decContext.c 
	ulocdata.c  utmscale.c decNumber.c
    )

concat(src_files
        indiancal.cpp   dtptngen.cpp dtrule.cpp   
        persncal.cpp    rbtz.cpp     reldtfmt.cpp 
        taiwncal.cpp    tzrule.cpp   tztrans.cpp  
        udatpg.cpp      vtzone.cpp                
	anytrans.cpp    astro.cpp    buddhcal.cpp 
	basictz.cpp     calendar.cpp casetrn.cpp  
	choicfmt.cpp    coleitr.cpp  coll.cpp     
	cpdtrans.cpp    csdetect.cpp csmatch.cpp  
	csr2022.cpp     csrecog.cpp  csrmbcs.cpp  
	csrsbcs.cpp     csrucode.cpp csrutf8.cpp  
	curramt.cpp     currfmt.cpp  currunit.cpp 
	datefmt.cpp     dcfmtsym.cpp decimfmt.cpp 
	digitlst.cpp    dtfmtsym.cpp esctrn.cpp   
	fmtable_cnv.cpp fmtable.cpp  format.cpp   
	funcrepl.cpp    gregocal.cpp gregoimp.cpp 
	hebrwcal.cpp    inputext.cpp islamcal.cpp 
	japancal.cpp    measfmt.cpp  measure.cpp  
	msgfmt.cpp      name2uni.cpp nfrs.cpp     
	nfrule.cpp      nfsubs.cpp   nortrans.cpp 
	nultrans.cpp    numfmt.cpp   olsontz.cpp  
	quant.cpp       rbnf.cpp     rbt.cpp      
	rbt_data.cpp    rbt_pars.cpp rbt_rule.cpp 
	rbt_set.cpp     regexcmp.cpp regexst.cpp  
	regeximp.cpp 
	rematch.cpp     remtrans.cpp repattrn.cpp 
	search.cpp      simpletz.cpp smpdtfmt.cpp 
	sortkey.cpp     strmatch.cpp strrepl.cpp  
	stsearch.cpp    tblcoll.cpp  timezone.cpp 
	titletrn.cpp    tolowtrn.cpp toupptrn.cpp 
	translit.cpp    transreg.cpp tridpars.cpp 
	ucal.cpp        ucol_bld.cpp ucol_cnt.cpp 
	ucol.cpp        ucoleitr.cpp ucol_elm.cpp 
	ucol_res.cpp    ucol_sit.cpp ucol_tok.cpp 
	ucsdet.cpp      ucurr.cpp    udat.cpp     
	umsg.cpp        unesctrn.cpp uni2name.cpp 
	unum.cpp        uregexc.cpp  uregex.cpp   
	usearch.cpp     utrans.cpp   windtfmt.cpp 
	winnmfmt.cpp    zonemeta.cpp 
	numsys.cpp      chnsecal.cpp 
	cecal.cpp       coptccal.cpp ethpccal.cpp 
	brktrans.cpp    wintzimpl.cpp plurrule.cpp 
	plurfmt.cpp     dtitvfmt.cpp dtitvinf.cpp 
	tmunit.cpp      tmutamt.cpp  tmutfmt.cpp  
	colldata.cpp    bmsearch.cpp bms.cpp      
        currpinf.cpp    uspoof.cpp   uspoof_impl.cpp 
        uspoof_build.cpp     
        regextxt.cpp    selfmt.cpp   uspoof_conf.cpp 
        uspoof_wsconf.cpp ztrans.cpp zrule.cpp  
        vzone.cpp       fphdlimp.cpp fpositer.cpp
        locdspnm.cpp    ucol_wgt.cpp 
        alphaindex.cpp  bocsu.cpp    decfmtst.cpp 
        smpdtfst.cpp    smpdtfst.h   tzfmt.cpp 
        tzgnames.cpp    tznames.cpp  tznames_impl.cpp 
        udateintervalformat.cpp  upluralrules.cpp
        )


set(c_includes 
	${LOCAL_PATH} 
	${LOCAL_PATH}/../common
)

set(local_cflags -D_REENTRANT -DU_I18N_IMPLEMENTATION -O3 -fvisibility=hidden)
set(local_ldlibs -lpthread -lm)


#
# Build for the target (device).
#

CLEAR_VARS()
set(LOCAL_SRC_FILES ${src_files})
concat(LOCAL_C_INCLUDES += ${c_includes}
                    #TODO: I don't think we need any of these for webOS 3.0.5
                    #abi/cpp/include 
                    #bionic 
                    #bionic/libstdc++/include 
                    #external/stlport/stlport
                    )
concat(LOCAL_CFLAGS ${local_cflags} -DPIC -fPIC)
##TODO Fix rematch.cpp bug:
#/home/kai/workspace/webos_dalvik/external/icu4c/i18n/rematch.cpp: In member function ‘void icu_49::RegexMatcher::MatchChunkAt(int32_t, UBool, UErrorCode&)’:
#/home/kai/workspace/webos_dalvik/external/icu4c/i18n/rematch.cpp:5653: error: unrecognizable insn: (insn 7199 2303 2305 301
#/home/kai/workspace/webos_dalvik/external/icu4c/i18n/rematch.cpp:4754 (set
#(reg:SI 11 fp)
#        (plus:SI (reg:SI 3 r3 [1441])
#                    (mult:SI (reg/v:SI 14 lr [orig:381 opValue.2253 ] [381])
#                                    (const_int 32 [0x20])))) -1 (nil))
#/home/kai/workspace/webos_dalvik/external/icu4c/i18n/rematch.cpp:5653:
#internal compiler error: in extract_insn, at recog.c:1990
#Please submit a full bug report,
#with preprocessed source if appropriate.
#See <http://gcc.gnu.org/bugs.html> for instructions.
concat(LOCAL_CFLAGS ${local_cflags} -DUCONFIG_ONLY_COLLATION=1)

set(LOCAL_RTTI_FLAG -frtti)
#TODO: I don't think we need gabi or stlport for webOS 3.0.5
#concat(LOCAL_SHARED_LIBRARIES icuuc gabi++ stlport)
concat(LOCAL_SHARED_LIBRARIES icuuc)
concat(LOCAL_LDLIBS ${local_ldlibs})
set(LOCAL_MODULE_TAGS optional)
set(LOCAL_MODULE icui18n)
BUILD_SHARED_LIBRARY()


# #
# # Build for the host.
# #
# 
# ifeq ($(WITH_HOST_DALVIK),true)
#     include $(CLEAR_VARS)
#     LOCAL_SRC_FILES := $(src_files)
#     LOCAL_C_INCLUDES := $(c_includes)
#     LOCAL_CFLAGS += $(local_cflags)
#     LOCAL_SHARED_LIBRARIES += libicuuc
#     LOCAL_LDLIBS += $(local_ldlibs)
#     LOCAL_MODULE_TAGS := optional
#     LOCAL_MODULE := libicui18n
#     include $(BUILD_HOST_SHARED_LIBRARY)
# endif
# #
