fio –blocksize=4k –direct=1 –numjobs=1 –directory=WORKINGDIRECTORY −  − ioengine = libaio −  − invalidate = 0 −  − timebased −  − name=BENCHMARK_NAME \
–nrfiles=1 –clat_percentiles=1 –max-jobs=1 –randrepeat=1 –create_serialize=0 –group_reporting –filename_format=jobnum/filenum’ –runtime=60 –rwmixread=0 \
–iodepth=256 –readwrite=randread –filesize=10485760000

