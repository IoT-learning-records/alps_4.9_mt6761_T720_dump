#!/system/bin/sh
PRELOAD_SOURCE=/system/tcard_backup
#PRELOAD_DEST=/storage/sdcard0/
PRELOAD_DEST1=$EXTERNAL_STORAGE    # /storage/sdcard0
PRELOAD_DEST2=$SECONDARY_STORAGE   # /storage/sdcard1

PRELOAD_FLAG_FOLDER=/data/app/
PRELOAD_FLAG=${PRELOAD_FLAG_FOLDER}/.preloadfile
#PRELOAD_FLAG=${PRELOAD_DEST}/.preloadfile

if [ ! -d ${PRELOAD_FLAG_FOLDER} ]
then
	mkdir -p ${PRELOAD_FLAG_FOLDER}
fi

# 检查是手机盘路径
# 插入T卡:  T卡   sdcard0
#           内置  sdcard1
# 不插T卡:  T卡   sdcard1
#           内置  sdcard0
# 即sdcard1 可用时,即是内置,否则就是 sdcard0 路径了

echo "t" > $PRELOAD_DEST2/.t
if [ -f $PRELOAD_DEST2/.t ]
then
PRELOAD_DEST=$PRELOAD_DEST2
rm -rf $PRELOAD_DEST2/.t
else
PRELOAD_DEST=$PRELOAD_DEST1
fi

mkdir -p /data/data/com.baidu.map.location/shared_prefs/
chmod -R 777 /data/data/com.baidu.map.location
chmod -R 777 /data/data/com.baidu.map.location/shared_prefs
cp -rf /system/etc/baidu_map_location/shared_prefs/pstate.xml  /data/data/com.baidu.map.location/shared_prefs
chmod -R 777 /data/data/com.baidu.map.location/shared_prefs/pstate.xml


PREINSTALLPATH=/system/preinstall

if [ ! -f ${PRELOAD_FLAG} ]
then
	
	APKS=`ls ${PREINSTALLPATH}/*.apk`
	for apk in ${APKS}
	do
    		pm install -f ${apk}
	done
	
	cp -rf ${PRELOAD_SOURCE}/. ${PRELOAD_DEST}
	
	if [ $? -eq 0 ];then 
	  echo "copy1" > ${PRELOAD_FLAG} 
	else
		cp -rf ${PRELOAD_SOURCE}/. ${PRELOAD_DEST}
		
		if [ $? -eq 0 ];then 
			echo "copy2" > ${PRELOAD_FLAG} 
		fi
	fi
	
	mkdir -p /data/data/com.google.android.inputmethod.pinyin/shared_prefs/
	chmod -R 777 /data/data/com.google.android.inputmethod.pinyin
	chmod -R 777 /data/data/com.google.android.inputmethod.pinyin/shared_prefs
	cp -rf /system/app/GooglePinyinPreference/com.google.android.inputmethod.pinyin_preferences.xml  /data/data/com.google.android.inputmethod.pinyin/shared_prefs
	chmod -R 777 /data/data/com.google.android.inputmethod.pinyin/shared_prefs/com.google.android.inputmethod.pinyin_preferences.xml
	
	# 发送广播,让媒体扫描程序重新扫描对应的目录,解决第一次开机,当视频文件比较大时,媒体扫描取得的文件大小不对的问题
	am broadcast -a "android.intent.action.MEDIA_SCANNER_SCAN_FILE" -d "file:$PRELOAD_DEST"
fi

