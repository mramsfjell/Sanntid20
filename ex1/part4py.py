# Python 3.3.3 and 2.7.6
# python part4py.py

from threading import Thread


# Potentially useful thing:
#   In Python you "import" a global variable, instead of "export"ing it when you declare it
#   (This is probably an effort to make you feel bad about typing the word "global")
i = 0

def incrementingFunction():
    global i

    for j in range(1000000):
      i = i+1

def decrementingFunction():
    global i

    for j in range(1000000):
      i = i-1



def main():

    incrementing = Thread(target = incrementingFunction, args = (),)
    decrementing = Thread(target = decrementingFunction, args = (),)

    incrementing.start()
    decrementing.start()

    incrementing.join()
    decrementing.join()

    print("The magic number is %d" % (i))


main()
