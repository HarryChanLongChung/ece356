import os.path
import sys
import graphviz 

from tqdm import tqdm
from sklearn import tree
from sklearn.model_selection import train_test_split

import utility_help as hp

def generate_sample_label(csvLocation):
    samples = []
    labels = []

    samples_csv = open(csvLocation, 'r')
    samples_csv.readline()

    for entry in samples_csv:
        playerId, features, label = hp.turn_string_to_sample(entry)

        samples.append(features)
        labels.append(label)

    samples_csv.close
    return samples, labels

def train_and_test_on_data(iteration, csvlocation, classifier_type):
    dataset = generate_sample_label(csvlocation)
    x_train, x_test, y_train, y_test = train_test_split(dataset[0], dataset[1], test_size=0.2)

    # training
    clf = tree.DecisionTreeClassifier(criterion=classifier_type)
    clf = clf.fit(x_train, y_train)

    dot_data = tree.export_graphviz(clf, out_file=None) 
    graph = graphviz.Source(dot_data) 
    graph.render("out/"+classifier_type+"_"+os.path.splitext(csvlocation)[0]) 

    cnt = 0
    correct = 0
    predictions = []
    # predicting
    for test_sample in x_test:
        test_result = clf.predict([test_sample])
        if test_result[0] ==  y_test[cnt]:
            correct += 1
        predictions.append(test_result)
        cnt += 1
    
    hp.print_precision_csv(iteration, y_test, predictions, classifier_type)

    accuracy = (correct/cnt)*100
    #print("Total: ", cnt, "Correct: ", correct, "Accuracy: ", accuracy)

    return accuracy

def multiple_data_set(iteration, classifier_type, csv_location):
    accuracy = [0]*iteration

    out = open("out/g14_DT_"+classifier_type+"_precision.csv", 'w')
    out.close

    for i in tqdm(range(iteration)):
        accuracy[i] = train_and_test_on_data(i, csv_location, classifier_type)

    hp.print_accuracy_csv(iteration, accuracy, classifier_type)
    print("Avg: ", sum(accuracy)/iteration, "CSV: ", csv_location)

if __name__ == "__main__":
    #python3 scikit_learn.py 5 entropy data2_7.csv
    #python3 scikit_learn.py 5 gini data2_7.csv
    
    i = int(sys.argv[1])
    multiple_data_set(iteration = i, classifier_type = sys.argv[2], csv_location = sys.argv[3])
