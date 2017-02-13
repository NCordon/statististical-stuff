#!/bin/bash


training=(train20 train40 train60 train80 train100)
datasets=(covertype kddcup protein pokerhand)


for train in ${training[*]}
do
    for d in ${datasets[*]}
    do
        echo "Haciendo J48 sobre ${train}-${d}"
        java -cp ~/weka-3-8-1/weka.jar -Xmx8g weka.classifiers.trees.J48 \
             -t ./data/${train}-${d}.arff -T ./data/test-${d}.arff > ./results/J48-${train}-${d}
        echo "Haciendo Random Forest sobre ${train}-${d}"
        java -cp ~/weka-3-8-1/weka.jar -Xmx8g weka.classifiers.trees.RandomForest -I 50 \
             -t ./data/${train}-${d}.arff -T ./data/test-${d}.arff > ./results/RF-${train}-${d}
        
    done
done
