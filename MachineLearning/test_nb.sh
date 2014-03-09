#! /bin/sh

echo "Training..."
python nbtrain.py acc_train nb_model
echo "Classifying..."
python nbclassify.py nb_model acc_test nb_output