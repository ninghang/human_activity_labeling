declare -a all_baseFile=(m1_100 m1_500 m1_1000 m2_100 m2_500 m2_1000 uniform_20_0 uniform_20_10 uniform_20_15 uniform_30_10 uniform_40_10)

type=training

mkdir -p jobs
cd jobs
rm -f job*

for baseFile in ${all_baseFile[@]}
do
    for noiseProb in $(seq 0 0.1 1)
    do
        wt=30
        jobfile=./job\_cv12\_$baseFile\_noise$noiseProb
        echo "#PBS -lnodes=1:ppn=8" > $jobfile
        echo "#PBS -lwalltime=$wt:00:00" >> $jobfile
        echo "cd ~/workspace/human_activity_labeling/svm_struct_learning" >> $jobfile
        for i in {1..2}
        do
            trainingList=$type\_$baseFile\_cv$i.txt
            model=model\_$baseFile\_cv$i\_$noiseProb
            echo "./svm_python_learn --m svmstruct_mrf_act -c 0.1 -e 0.01 -w 3 --sf false --noise $noiseProb --temporal true $trainingList $model &" >> $jobfile
        done
        echo "wait" >> $jobfile

        wt=30
        jobfile=./job\_cv34\_$baseFile\_noise$noiseProb
        echo "#PBS -lnodes=1:ppn=8" > $jobfile
        echo "#PBS -lwalltime=$wt:00:00" >> $jobfile
        echo "cd ~/workspace/human_activity_labeling/svm_struct_learning" >> $jobfile
        for i in {3..4}
        do
            trainingList=$type\_$baseFile\_cv$i.txt
            model=model\_$baseFile\_cv$i\_$noiseProb
            echo "./svm_python_learn --m svmstruct_mrf_act -c 0.1 -e 0.01 -w 3 --sf false --noise $noiseProb --temporal true $trainingList $model &" >> $jobfile
        done
        echo "wait" >> $jobfile

    done
done


