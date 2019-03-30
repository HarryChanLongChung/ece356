import os.path
import sys

from tqdm import tqdm
from sklearn import tree

def prune(input_list):
    l = []

    for e in input_list:
        e = e.strip()
        #if e != '' and e != ' ':
        l.append(e)

    return l

def get_leagueid_switch():
    switcher = {
        "UA":1,
        "AL":2,
        "NL":3,
        "PL":4,
        "NA":5,
        "AA":6,
        "FL":7
    }
    return switcher

def turn_string_to_sample(inputString):
    elems = inputString.strip().split(',')
    elems = prune(elems)
    #elems = [int(x) for x in elems]
    samples = []
    leagueId_case = get_leagueid_switch()

    for x in elems[1:]:
        if x == "NULL" or x == "null" or x == "":
            samples.append(-1)
        elif not x.isdigit():
            samples.append(leagueId_case.get(x, -1))
        else:
            samples.append(int(x))

    return samples[0], samples[1:-1], samples[-1]

def generate_sample_label(csvLocation):
    samples = []
    labels = []

    samples_csv = open(csvLocation, 'r')
    samples_csv.readline()

    for entry in samples_csv:
        playerId, features, label = turn_string_to_sample(entry)

        samples.append(features)
        labels.append(label)

    samples_csv.close
    return samples, labels

def train_and_test_on_data(csvlocation):
    dataset = generate_sample_label(csvlocation)
    split = int(len(dataset[0]) * 0.8)

    # training
    clf = tree.DecisionTreeClassifier()
    clf = clf.fit(dataset[0][0:split], dataset[1][0:split])

    cnt = 0
    correct = 0
    # predicting
    for test_sample in dataset[0][split:]:
        test_result = clf.predict([test_sample])
        if test_result ==  dataset[1][split + cnt]:
            correct += 1
        cnt += 1
    
    accuracy = (correct/cnt)*100
    #print("Total: ", cnt, "Correct: ", correct, "Accuracy: ", accuracy)

    return accuracy

def multiple_data_set(iteration, csv_locations):
    accuracy = [0]*len(csv_locations)

    for _ in tqdm(range(iteration)):
        for u in range(len(accuracy)):
            accuracy[u] += train_and_test_on_data(csv_locations[u])
    
    for u in range(len(accuracy)):
        print("Avg: ", accuracy[u]/iteration, "CSV: ", csv_locations[u])

if __name__ == "__main__":
    i = int(sys.argv[1])
    csv_locations = sys.argv[2:]
    multiple_data_set(i, csv_locations)

