CC = clang

CFLAGS = -Wall -g -std=c99 
LDFLAGS = -lpthread -g
SRC = part4c.c

TARGET = part4c

all: $(TARGET)

# Define all object files.
OBJ = $(SRC:.c=.o)

# rule to link the program
$(TARGET): $(OBJ)
	$(CC) $^ -o $@ $(LDFLAGS)

# Compile: create object files from C source files.
%.o : %.c
	$(CC) $(CFLAGS) -c  $< -o $@ 

# rule for cleaning re-compilable files.
clean:
	rm -f $(TARGET) $(OBJ)

rebuild:	clean all

.PHONY: all rebuild clean
