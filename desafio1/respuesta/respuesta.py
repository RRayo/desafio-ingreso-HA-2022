import json
from collections import Counter

# tuples [x, y] 
# x, y days of the year [0,364]
# x first day seen, y day not seen
# calculate the density of titans for each day 
# and get the first day with the lowest density of titans
# (use the least amount of loops)

# questions: memory restrictions?
# questions: time restrictions?
# questions: el output debe especificar el día mes y año? ej día (369, 4) estaría bien?

# read the file and save the data in a list
def read_file(file_name):
    data = []
    file = open(file_name, 'r')
    raw_data = json.load(file)
    for x, y in raw_data:
        data.extend(list(range(x, y)))
    file.close()
    return data

# calculate the density of titans for each day
def least_occurrences(data, condition=None):
    counter = Counter(data)
    if callable(condition):
        counter = Counter({k: v for k, v in counter.items() if condition(k)})
    least_common = counter.most_common()[-1]
    least_amount = least_common[1]
    # if there are more than one day with the same density, get the first one
    least_common_days = [k for k, v in counter.most_common() if v == least_amount]

    return min(least_common_days), least_amount

days_with_titans = read_file('desafio1\last_year.json')

# ignore the months of january and december
condition = lambda x: x%365 not in range(0, 31) and x%365 not in range(334, 365)

least_common = least_occurrences(days_with_titans, condition)
print(least_common[0])
