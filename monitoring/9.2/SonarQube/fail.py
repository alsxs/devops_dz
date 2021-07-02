def increment(index):
    index += 1
    return index


def get_square(numb):
    return numb*numb


def print_numb(numb):
    print("Number is {}".format(numb))
    pass


ind = 0
while ind < 10:
    ind = increment(ind)
    print(get_square(ind))
