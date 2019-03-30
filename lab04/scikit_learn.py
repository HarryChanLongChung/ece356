import os.path

from sklearn import tree
from tqdm import tqdm

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

    for x in elems:
        if x == "NULL" or x == "null" or x == "":
            samples.append(-1)
        elif not x.isdigit:
            samples.append(leagueId_case.get(x, -1))
        else:
            samples.append(int(x))

    return samples[0], samples[1:-1], samples[-1]

def generate_sample_label(csvLocation):
    samples = []
    labels = []

    samples_csv = open(csvLocation, 'r')

    for entry in tqdm(samples_csv):
        playerId, features, label = turn_string_to_sample(entry)

        samples.append(features)
        labels.append(label)

    samples_csv.close
    return samples, labels

if __name__ == "__main__":

    dataset = generate_sample_label("samples.csv")
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
    
    print("Total sample tested: ", cnt)
    print("Total correct answer:", correct)
    print("Correct Percentage", (correct/cnt)*100)




