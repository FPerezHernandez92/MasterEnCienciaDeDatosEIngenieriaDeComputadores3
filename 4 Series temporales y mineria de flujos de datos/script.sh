#!/bin/bash

for ejercicio in `seq 1 2`
do
	for SEMILLA in `seq 1 5`
	do
		echo -e "\n\nEl valor de la semilla es: " $SEMILLA >> $ejercicio
		if [ $ejercicio -eq 1 ]
		then
			echo -e "\nPrimero HoeffdingTree: " >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "EvaluateModel -m (LearnModel -l trees.HoeffdingTree -s (generators.WaveformGenerator -i $SEMILLA) -m 1000000) -s (generators.WaveformGenerator -i 4)" >> $ejercicio	
			echo -e "\nAhora HoeffdingAdaptativeTree" >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "EvaluateModel -m (LearnModel -l trees.HoeffdingAdaptiveTree -s (generators.WaveformGenerator -i $SEMILLA) -m 1000000) -s (generators.WaveformGenerator -i 4)" >> $ejercicio
		fi

		if [ $ejercicio -eq 2 ]
		then
			echo -e "\nPrimero HoeffdingTree: " >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "EvaluateInterleavedTestThenTrain -l moa.classifiers.trees.HoeffdingTree -s (generators.WaveformGenerator -i $SEMILLA) -i 1000000 -f 10000" >> $ejercicio	
			echo -e "\nAhora HoeffdingAdaptativeTree" >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "EvaluateInterleavedTestThenTrain -l moa.classifiers.trees.HoeffdingAdaptiveTree -s (generators.WaveformGenerator -i $SEMILLA) -i 1000000 -f 10000" >> $ejercicio
		fi

		if [ $ejercicio -eq 3 ]
		then
			echo -e "\nPrimero HoeffdingTree: " >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "" >> $ejercicio	
			echo -e "\nAhora HoeffdingAdaptativeTree" >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "" >> $ejercicio
		fi

		if [ $ejercicio -eq 4 ]
		then
			echo -e "\nPrimero HoeffdingTree: " >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "" >> $ejercicio	
			echo -e "\nAhora HoeffdingAdaptativeTree" >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "" >> $ejercicio
		fi

		if [ $ejercicio -eq 5 ]
		then
			echo -e "\nPrimero HoeffdingTree: " >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "" >> $ejercicio	
			echo -e "\nAhora HoeffdingAdaptativeTree" >> $ejercicio
			java -cp moa-release-2016.04/moa.jar -javaagent:moa-release-2016.04/sizeofag.jar moa.DoTask "" >> $ejercicio
		fi
	done
done