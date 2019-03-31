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
