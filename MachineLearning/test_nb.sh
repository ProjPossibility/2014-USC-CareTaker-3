#! /bin/sh

echo "Training..."
python nb_classifier/nbtrain.py intermediate_data_files/acc_train nb_classifier/nb_model
echo "Classifying..."
python nbclassify.py nb_classifier/nb_model intermediate_data_files/acc_test nb_classifier/nb_output
