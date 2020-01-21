### 訓練データ作成

```
tesstrain.sh \
--fonts_dir /usr/share/fonts \
--lang jpn \
--fontlist "TakaoGothic" "TakaoPGothic" "VL Gothic" "VL PGothic" "Noto Sans JP Bold" "Noto Sans JP Light" \
--linedata_only \
--langdata_dir /tmp/langdata
```

```
lstmtraining \
--model_output /home \
--continue_from ${TESSDATA_PREFIX}/jpn.traineddata  \
--traineddata ${TESSDATA_PREFIX}/jpn.traineddata  \
--train_listfile /tmp/tesstrain/tessdata/jpn.training_files.txt \
--max_iterations 1000
```

```
combine_tessdata \
-e /usr/local/share/tessdata/jpn.traineddata \
/tmp/jpn.lstm
```

```
 lstmtraining --stop_training \
 --continue_from ~/tess/katakana/400_checkpoint --traineddata ~/tess/training_bs/jpn/jpn.traineddata --model_output $TESSDATA_PREFIX/katakana_400.traineddata
```