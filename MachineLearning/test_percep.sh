#! /bin/sh

echo "Training..."
python train.py acc_train percep_model 20
echo "Classifying..."
python classify.py percep_model acc_test percep_output