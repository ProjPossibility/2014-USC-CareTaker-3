#! /bin/sh

echo "Training..."
python perceptron/train.py intermediate_data_files/acc_train perceptron/percep_model 10
echo "Classifying..."
python perceptron/classify.py perceptron/percep_model intermediate_data_files/acc_test perceptron/percep_output
