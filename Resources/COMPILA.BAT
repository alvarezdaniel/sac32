@echo off
brc32 -foFILES.res -v -r FILES.rc
copy FILES.res ..
rem brc32 -foVERSION.res -v -r VERSION.rc
rem copy VERSION.res ..

