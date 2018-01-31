#!/bin/sh

OS=`uname`
LANG=C
export LANG
RESULT_FILE="script.txt"
LOG_FILE="scriptlog.txt"

clear

echo "Checking System Time : `date`"
echo "========================== 진단 시작 ========================="
echo ""
echo ""
echo "------------------------------------" 
echo "[U-04] 패스워드 파일 보호" 
echo "------------------------------------" 
RESULT=GOOD
CHECK_FILE=/etc/shadow
if [ -f ${CHECK_FILE} ] ; then
    ls -al ${CHECK_FILE}
    echo "양호: ${CHECK_FILE} 파일 있음" 
else
    echo "취약: ${CHECK_FILE} 파일 없음"
    RESULT=BAD
fi
CHECK_FILE=/etc/passwd
if [ -f ${CHECK_FILE} ] ; then
    if [ `cat ${CHECK_FILE} | awk -F":" '{print $2}' | grep -v "x" | wc -l` -eq 0 ] ; then
        echo "양호: ${CHECK_FILE}의 두 번째 필드가 모두 x표시임" 
    else
		 echo "취약: ${CHECK_FILE}의 두 번째 필드에 x표기가 아닌 것이 존재함" 
        RESULT=BAD
    fi
else
	echo "취약: ${CHECK_FILE} 파일 없음" 
    RESULT=BAD
fi
echo "[U-04]:${RESULT}" > ${RESULT_FILE}
echo "------------------------------------" 
echo ""
echo ""
echo "------------------------------------" 
echo "[U-05] root 이외의 UID가 '0' 금지" 
echo "------------------------------------"
RESULT=GOOD
CHECK_FILE=/etc/passwd
if [ -f ${CHECK_FILE} ] ; then
    if [ `cat ${CHECK_FILE} | grep -v "^root:"  | awk -F":" '{ if ($3 == 0) print $0}' | wc -l` -eq 0 ] ; then
        echo "양호: ${CHECK_FILE}의 UID가 root외에는 0이 없음" 
    else
        echo "취약: ${CHECK_FILE}의 UID가 root외에는 0이 존재함"
        cat ${CHECK_FILE} | grep -v "^root:"  | awk -F":" '{ if ($3 == 0) print $0}'
        RESULT=BAD
    fi

else
    echo "취약: ${CHECK_FILE} 파일 없음" 
    RESULT=BAD
fi
echo "[U-05]:${RESULT}" >> ${RESULT_FILE}
echo "------------------------------------" 
echo ""
echo ""
echo "------------------------------------" 
echo "[U-06] root 계정 su 제한" 
echo "------------------------------------" 
RESULT=GOOD
CHECK_FILE=/bin/su
if [ -f ${CHECK_FILE} ] ; then
    ls -al ${CHECK_FILE}
    if [ `ls -al ${CHECK_FILE} | awk -F" " '{print $1}' | grep -v '\-rwsr-x---' | wc -l` -eq 0 ] ; then
        echo "양호: ${CHECK_FILE} 파일의 권한은 적절하게 설정되어 있습니다." 
    else
        echo "취약: ${CHECK_FILE} 파일의 권한은 기준(4750)와 다릅니다." 
        RESULT=BAD
    fi
else
    echo "취약: ${CHECK_FILE} 파일 없음"
    RESULT=BAD
fi
echo "[U-06]:${RESULT}" >> ${RESULT_FILE}
echo "------------------------------------" 
echo ""
echo ""
echo "------------------------------------" 
echo "[U-07] 패스워드 최소 길이 설정" 
echo "------------------------------------" 
RESULT=GOOD
CHECK_FILE=/etc/login.defs
if [ -f ${CHECK_FILE} ] ; then
    CHECK_LIST=PASS_MIN_LEN
    if [ `cat ${CHECK_FILE} | grep -v "^#" | grep "${CHECK_LIST}" | wc -l` -eq 0 ] ; then
        echo "취약: ${CHECK_FILE}에 ${CHECK_LIST} 라인 없음" 
        RESULT=BAD
    else

        if [ `cat ${CHECK_FILE} | grep -v "^#" | grep "${CHECK_LIST}" | awk '{print $2}'` -lt 8 ] ; then
            echo "취약: ${CHECK_LIST}이 8 보다 작음" 
            RESULT=BAD
        else
            echo "양호: ${CHECK_LIST}이 8 이상임" 
        fi
    fi
else
    echo "파일(${CHECK_FILE}) 없음" 
    RESULT=CHECK
fi
echo "[U-07]:${RESULT}">> ${RESULT_FILE}
echo "------------------------------------" 
echo ""
echo ""
echo "------------------------------------" 
echo "[U-08] 패스워드 최대 사용기간 설정" 
echo "------------------------------------"
RESULT=GOOD
CHECK_FILE=/etc/login.defs
if [ -f ${CHECK_FILE} ] ; then
    CHECK_LIST=PASS_MAX_DAYS
    
    if [ `cat ${CHECK_FILE} | grep -v "^#" | grep "${CHECK_LIST}" | wc -l` -eq 0 ] ; then
        echo "취약: ${CHECK_FILE}에 ${CHECK_LIST} 라인 없음"
        RESULT=BAD
    else

        if [ `cat ${CHECK_FILE} | grep -v "^#" | grep "${CHECK_LIST}" | awk '{print $2}'` -gt 90 ] ; then
            echo "취약: ${CHECK_LIST}이 90 보다 큼"
            RESULT=BAD
        else
            echo "양호: ${CHECK_LIST}이 90 이하임"
        fi
    fi
else
    echo "파일(${CHECK_FILE}) 없음" 
    RESULT=CHECK
fi
echo "[U-08]:${RESULT}" >> ${RESULT_FILE}
echo "------------------------------------" 

sleep 3s

./client



