// Use `go run foo.go` to run your program

package main

import (
	. "fmt"
	"runtime"
)

// Control signals
const (
	GetNumber = iota
	Exit
)

func number_server(add_number <-chan int, control <-chan int, number chan<- int) {
	var i = 0

	// This for-select pattern is one you will become familiar with if you're using go "correctly".
	for {
		select {
		// Receive different messages and handle them correctly
		// You will at least need to update the number and handle control signals.
			case j := <-add_number:
				i += j
			case status := <-control:
				if status == GetNumber {
					Println("Received 1st on control line")
					number <- i
				} else {
					Println("Received 2nd on control line") // Sometimes doesn't run (main might exit before it gets to?)
					return
				}
		}
	}
}

func incrementing(add_number chan<- int, finished chan<- bool) {
	for j := 0; j < 1000000; j++ {
		add_number <- 1
	}
	// Signal that the goroutine is finished
	Println("Finished incrementing")
	finished <- true
}

func decrementing(add_number chan<- int, finished chan<- bool) {
	for j := 0; j < 1000000; j++ {
		add_number <- -1
	}
	// Signal that the goroutine is finished
	Println("Finished decrementing")
	finished <- true
}

func main() {
	runtime.GOMAXPROCS(16) // Manually set high instead of runtime.NumCPU() to ensure proper concurrency

	// Construct the required channels
	// Think about whether the receptions of the number should be unbuffered, or buffered with a fixed queue size.
	control := make(chan int)
	add_number := make(chan int)
	number := make(chan int)
	finished := make(chan bool)

	// Spawn the required goroutines
	go number_server(add_number, control, number)
	go incrementing(add_number, finished)
	go decrementing(add_number, finished)

	// Block on finished from both "worker" goroutines
	_, _ = <-finished, <-finished

	control <- GetNumber
	Println("The magic number is:", <-number)
	control <- Exit
}

