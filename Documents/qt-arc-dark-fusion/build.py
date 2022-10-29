#!/bin/python
import logging
import qtsass

def main():
    qtsass.enable_logging(level=logging.DEBUG)
    print("Compiling theme into QSS")
    qtsass.compile_dirname("./scss", "./out")
    print("Finished!")

if __name__ == "__main__":
    main()