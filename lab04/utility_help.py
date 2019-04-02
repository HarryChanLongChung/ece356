import os.path

from sklearn.metrics import classification_report

def prune(input_list):
    l = []

    for e in input_list:
        e = e.strip()
        #if e != '' and e != ' ':
        l.append(e)

    return l

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

def print_accuracy_csv(iteration, accuracy, clf_type):
    out = open("out/g14_DT_"+clf_type+"_accuracy.csv", 'w')

    content = "datasetNumber, Accuracy,\n"
    i=0
    if iteration == len(accuracy):
        for ac in accuracy:
            content += str(i) + ", " + str(ac) + ",\n"
            i += 1

        out.write(content)
        out.close

def print_precision_csv(iteration, classification, prediction, clf_type):
    out = open("out/g14_DT_"+clf_type+"_precision.csv", 'a')

    content = ""

    if iteration == 0:
        content = "iteration, classification, prediction\n"
    for u in range(len(classification)):
        content += str(iteration) + ", "
        content += str(classification[u]) + ", "
        content += str(prediction[u][0]) + ",\n"

    labels = ['nominated', 'elected']
    print(classification_report(classification, prediction, target_names=labels))

    out.write(content)
    out.close

