declare -a all_baseFile=(m1_100 m1_500 m1_1000 m2_100 m2_500 m2_1000 uniform_20_0 uniform_20_10 uniform_20_15 uniform_30_10 uniform_40_10)

type=training

for baseFile in ${all_baseFile[@]}
do
    for noiseProb in $(seq 0 0.1 1)
    do
        for i in {1..4}
        do
            trainingList=$type\_$baseFile\_cv$i.txt
            model=model\_$baseFile\_cv$i\_$noiseProb.txt
            echo ./svm_python_learn --m svmstruct_mrf_act -c 0.1  -e 0.01 -w 3 --sf false --noise $noiseProb --temporal true $trainingList $model
        done
    done
done


