declare -a all_baseFile=(m1_100 m1_500 m1_1000 m2_100 m2_500 m2_1000 uniform_20_0 uniform_20_10 uniform_20_15 uniform_30_10 uniform_40_10)

type=test

mkdir -p jobs
cd jobs
rm -f job*

for baseFile in ${all_baseFile[@]}
do
    for noiseProb in $(seq 0 0.1 1)
    do
        wt=10
        jobfile=./job\_cv12\_$baseFile\_noise$noiseProb
        echo "#PBS -lnodes=1:ppn=8" > $jobfile
        echo "#PBS -lwalltime=$wt:00:00" >> $jobfile
        echo "cd ~/workspace/human_activity_labeling/svm_struct_learning" >> $jobfile
        for i in {1..2}
        do
            trainingList=$type\_$baseFile\_cv$i.txt
            model=model\_$baseFile\_cv$i\_$noiseProb
            pred=prec\_$baseFile\_cv$i\_$noiseProb
            echo "./svm_python_classify --m svmstruct_mrf_act --sf false --temporal true $trainingList $model $pred &" >> $jobfile
        done
        echo "wait" >> $jobfile

        wt=10
        jobfile=./job\_cv34\_$baseFile\_noise$noiseProb
        echo "#PBS -lnodes=1:ppn=8" > $jobfile
        echo "#PBS -lwalltime=$wt:00:00" >> $jobfile
        echo "cd ~/workspace/human_activity_labeling/svm_struct_learning" >> $jobfile
        for i in {3..4}
        do
            trainingList=$type\_$baseFile\_cv$i.txt
            model=model\_$baseFile\_cv$i\_$noiseProb
            pred=prec\_$baseFile\_cv$i\_$noiseProb
            echo "./svm_python_classify --m svmstruct_mrf_act --sf false --temporal true $trainingList $model $pred &" >> $jobfile
        done
        echo "wait" >> $jobfile

    done
done


