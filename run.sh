hadoop jar contrib/streaming/hadoop-streaming-1.2.1.jar \
    - file mapper1.py - mapper mapper1.py \
    - file reducer1.py - reducer reducer1.py \
    - input user/input/hadoop_mini_data.csv - output user/output/all_accidents
    
hadoop jar contrib/streaming/hadoop-streaming-1.2.1.jar \
    -file mapper2.py -mapper mapper2.py \
    -file reducer2.py -reducer reducer2.py \
    -input user/output/all_accidents -output output/make_year_count
